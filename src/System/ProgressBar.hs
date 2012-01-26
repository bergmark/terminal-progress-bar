{-# LANGUAGE NoImplicitPrelude, PackageImports, UnicodeSyntax #-}

module ProgressBar ( progressBar ) where

import "base" Control.Monad ( when )
import "base" Data.Function ( ($) )
import "base" Data.List     ( genericReplicate )
import "base" Data.Ratio    ( (%) )
import "base" Data.String   ( String )
import "base" Prelude       ( (-), round )
import "base" System.IO     ( IO, putStr, putChar )
import "base" Text.Printf   ( printf )
import "base-unicode-symbols" Data.Eq.Unicode ( (≢) )
import "base-unicode-symbols" Prelude.Unicode ( ℤ, ℚ, (⋅) )


-- | Print a progress bar
--
-- Erases the current line! (by outputting '\r') Does not print a
-- newline '\n'. Subsequent invocations will overwrite the previous
-- output.

-- TODO: if labels decrease in size in subsequent calls the last
-- characters are not erased:
--
-- putStr "example"
-- > example
-- putStr "example" >> putStr "\r"
-- > example
-- putStr "example" >> putStr "\r" >> putStr "foo"
-- > foomple
progressBar ∷ String -- ^ Prefixed label.
            → String -- ^ Postfixed label.
            → ℤ      -- ^ Width in characters.
            → ℚ      -- ^ Current progress.
            → IO ()
progressBar preLabel postLabel width fraction = do
    putChar '\r'
    putStr $ progressBarString width fraction


progressBarString ∷ ℤ → ℚ → String
progressBarString width fraction =
    printf "%3i%% [%s%s]"
           percentage
           (genericReplicate completed '=')
           (genericReplicate remaining '.')
  where
    percentage ∷ ℤ
    percentage = round $ fraction ⋅ 100
    completed = round $ fraction ⋅ (width % 1)
    remaining = width - completed
