# Vim Online Thesaurus

This is a plugin for Vim allowing you to look up words in an online thesaurus,
which is at the moment configured to be http://thesaurus.com/ for the default language (English).

The plugin displays the definition of the word under the cursor and a list of
synonyms.

![](https://github.com/ggbioing/vim-online-thesaurus/raw/master/screenshot.png)

The credit for the original idea and code goes to Nick Coleman:
http://www.nickcoleman.org/


## Installation

If you are using Vundle, just add the following line to your .vimrc:

```
Plugin 'ggbioing/vim-online-thesaurus'
```

Then run `:PluginInstall` to install the plugin.

Note: Earlier versions required the "Bundle" keyword instead of plugin (i.e. :BundleInstall
and Bundle 'ggbioing/vim-online-thesaurus').
However, this is deprecated and should not be used any longer.


## Usage

The plugin provides the `:OnlineThesaurusCurrentWord` command to look up the
current word under the cursor in an online thesaurus. Alternatively, you can
look up any word with `:Thesaurus word`.

Internally, both commands make a request to http://thesaurus.com/, parse the
results, and display them in a vertical split in the bottom.

By default the `:OnlineThesaurusCurrentWord` command is mapped to
`<LocalLeader>K`.  If you haven't remapped `<LocalLeader>`, it defaults to `\`.
To close the split, just press `q`.

## Languages

Default language is English.
Append 'IT' to every command to lookup words into an Italian thesaurus (e.g. `:OnlineThesaurusCurrentWordIT`)
Append 'FR' for French (e.g. `:OnlineThesaurusCurrentWordFR`)

## Configuration

If you want to disable the default key binding, add the following line to your
.vimrc:

```
let g:online_thesaurus_map_keys = 0
```

Then you can map the `:OnlineThesaurusCurrentWord` command to anything you want
as follows:

```
nnoremap <your key binding> :OnlineThesaurusCurrentWord<CR>
```

Enjoy!


## Contributors

Big thanks to the following people who contributed to the development of this
plugin!

  - [Derek Schrock](https://github.com/derekschrock)
  - [Justin Campbell](https://github.com/justincampbell)
  - [Christian Heinrich](https://github.com/Shurakai)
  - [Matija Brković](https://github.com/blablatros)
  - [Shahaf Arad](https://github.com/av3r4ge)
  - [Luigi Antelmi](https://github.com/ggbioing)


## License

Copyright (c) Anton Beloglazov, Google Inc. Distributed under the Apache 2.0
License.
