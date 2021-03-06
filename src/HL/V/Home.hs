{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- | Home/landing page.

module HL.V.Home where

import HL.V hiding (list)
import HL.V.Code
import HL.V.Template
import HL.V.Home.Features

-- | Home view.
homeV :: [(Text, Text, Text)] -> FromSenza App
homeV vids =
  skeleton
    "Haskell Language"
    (\_ _ ->
       linkcss "http://fonts.googleapis.com/css?family=Ubuntu:700")
    (\cur url ->
       do navigation False Nothing url
          header url
          try url
          community url vids
          features
          events
          div [class_ "mobile"]
              (navigation False cur url))
    (\_ url ->
       scripts url
               [js_jquery_console_js
               ,js_tryhaskell_js
               ,js_tryhaskell_pages_js])

-- | Top header section with the logo and code sample.
header :: (Route App -> AttributeValue) -> Senza
header url =
  div [class_ "header"]
      (container
         (row
            (do span6 []
                      (div [class_ "branding"]
                           (do branding
                               summation))
                span6 []
                      (div [class_ "branding"]
                           (do tag
                               sample)))))
  where branding =
          span [class_ "name"
               ,background url img_logo_png]
               "Haskell"
        summation =
          span [class_ "summary"]
               "An advanced purely-functional programming language"
        tag =
          span [class_ "tag"]
               "Natural, declarative, statically typed code."
        sample = div [class_ "code-sample"]
                     (haskellPre codeSample)

-- | Code sample.
-- TODO: should be rotatable and link to some article.
codeSample :: Text
codeSample =
  "primes = sieve [2..]\n\
  \    where sieve (p:xs) = \n\
  \      p : sieve [x | x <- xs, x `mod` p /= 0]"

-- | Try Haskell section.
try :: (Route App -> AttributeValue) -> Senza
try _ =
  div [class_ "try"]
      (container
         (row
            (do span6 [] repl
                span6 [id "guide"] (return ()))))
  where
    repl =
      do h2 [] "Try it"
         div [id "console"] (return ())

-- | Community section.
-- TOOD: Should contain a list of thumbnail videos. See mockup.
community :: (Route App -> AttributeValue) -> [(Text, Text, Text)] -> Senza
community url vids =
  do div [class_ "community"
         ,background url img_community_jpg]
         (do container
               (row
                  (span8 []
                         (do h1 []
                                "An open source community effort for over 20 years"
                             p [class_ "learn-more"]
                               (a [href (url CommunityR)]
                                  "Learn more")))))
     div [class_ "videos"]
         (container (row (span12 [] (ul [] (forM_ vids vid)))))
  where
    vid (n,u,thumb) =
      li []
         (a [href (toValue u)
            ,title (toValue n)]
            (img [src (toValue thumb)]))

-- | Events section.
-- TODO: Take events section from Haskell News?
events :: Senza
events =
  return ()
