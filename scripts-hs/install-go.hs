#!/usr/bin/env stack
-- stack --resolver lts-12.19 script
{-# LANGUAGE OverloadedStrings #-}
import Turtle
import Control.Monad
import Control.Monad.Managed
import Turtle.Format
import Prelude hiding (FilePath)

goDownloadBaseUrl :: Text
goDownloadBaseUrl = "https://dl.google.com/go"

mkDownloadUrl :: Text -> Text -> Text
mkDownloadUrl version arch = format (""%s%"/"%s%"") goDownloadBaseUrl (mkArchiveName version arch)

mkArchiveName :: Text -> Text -> Text
mkArchiveName version arch  = format (""%s%"."%s%".tar.gz") version arch  

mkInstallDir :: FilePath 
mkInstallDir = fromText "/usr/local/go"

rmExistingInstallation :: FilePath -> Shell () 
rmExistingInstallation installdir = do
        installDirExists <- testdir installdir
        case installDirExists of
          True  -> doRm installdir
          False -> return ()
      where
        doRm f = do
          let cmd = format ("sudo rm -r "%fp%" ") f
          r <- shell cmd empty
          case r of
            ExitSuccess   -> return ()
            ExitFailure n -> die (cmd <> " failed with exit code" <> repr n)

parser :: Parser (Text, Text)
parser = (,) <$> optText "arch" 'a' "Your architecture, for example: linux-amd64, darwin-amd64"
             <*> optText "version" 'v' "The version of Go, for example: go1.11.0"


unpack :: FilePath -> Text -> Shell ()
unpack archiveLocation archiveName =  do
        let archiveLocationAsText = format fp (archiveLocation </> (fromText archiveName))
        let archivePath = format fp (archiveLocation)
        let cmd = format ("tar -C "%s%" -xf "%s%"") archivePath archiveLocationAsText 
        liftIO (print cmd)
        r <- (shell cmd empty )
        case r of
          ExitSuccess   -> return ()
          ExitFailure n -> die (cmd <> " failed with exit code" <> repr n)

download :: FilePath -> Text -> Shell ()
download downloadTo url =  do
        let downloadToAsText = format fp (downloadTo)
        let cmd = format ("wget "%s%" -P "%s%" ") url downloadToAsText --wget "$url" -P "$TMP_DIR"
        r <- (shell cmd empty )
        case r of
          ExitSuccess   -> return ()
          ExitFailure n -> die (cmd <> " failed with exit code" <> repr n)


installFromCache :: FilePath -> FilePath -> Shell ()
installFromCache installdir cachedir = do
          rmExistingInstallation installdir
          let cacheStr = format fp (cachedir)
          let cmd = format ("sudo cp -r "%fp%"/go "%fp%"") cachedir installdir
          liftIO (print cmd)
          stdout (inshell cmd empty)

installFromDownload :: FilePath -> FilePath -> Text -> Text -> Shell ()
installFromDownload installdir cachedir version arch = do
          download cachedir (mkDownloadUrl version arch)
          unpack cachedir (mkArchiveName version arch)
          rmExistingInstallation installdir
          let cacheStr = format fp (cachedir)
          let cmd = format ("sudo cp -r "%fp%"/go "%fp%"") cachedir installdir
          liftIO (print cmd)
          stdout (inshell cmd empty)


main :: IO ()
main = sh (do
        (arch, version) <- options "" parser
        liftIO (print arch)
        liftIO (print version)
        h <- home
        let cacheDir = h </> (fromText ".install_go") </> (fromText version)
        let installDir = mkInstallDir
        cacheExists <- testdir cacheDir
        case cacheExists of
          True -> installFromCache installDir cacheDir
          False -> installFromDownload installDir cacheDir version arch
        liftIO (print "Done"))
