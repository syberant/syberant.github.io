--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Text.Pandoc.Options

{- TODO:
- https://tony-zorman.com/posts/block-sidenotes.html :: Sidenotes instead of footnotes
- https://jaspervdj.be/hakyll/tutorials/05-snapshots-feeds.html :: RSS/Atom/JSON feeds
- https://tony-zorman.com/posts/katex-with-hakyll :: Server-side LaTeX rendering
-}
--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "assets/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "katex/**" $ do
        route   idRoute
        compile copyFileCompiler

    -- TODO: Add about and contact pages
    match (fromList [ ]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ myPandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

myPandocCompiler :: Compiler (Item String)
myPandocCompiler = pandocCompilerWith myReaderOptions myWriterOptions

myWriterOptions :: WriterOptions
myWriterOptions = defaultHakyllWriterOptions
      { writerHTMLMathMethod = MathJax ""
      }

myReaderOptions :: ReaderOptions
myReaderOptions =  defaultHakyllReaderOptions
    { readerExtensions = (readerExtensions defaultHakyllReaderOptions) <> extensionsFromList
               [ Ext_tex_math_dollars           -- TeX math between $..$ or $$..$$
               , Ext_tex_math_single_backslash  -- TeX math btw (..) [..]
               , Ext_tex_math_double_backslash  -- TeX math btw \(..\) \[..\]
               , Ext_latex_macros               -- Parse LaTeX macro definitions (for math only)
               , Ext_inline_code_attributes     -- Ext_inline_code_attributes
               ]
    }
