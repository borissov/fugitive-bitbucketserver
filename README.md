# fugitive-bitbucketserver

## Installation

Via Plugin Manager
#### Vundle
```viml
    Plugin 'borissov/fugitive-bitbucketserver'
```
#### VIM Plug 
```viml
    Plug 'borissov/fugitive-bitbucketserver'
```
### Manual Installation
```bash
cd ~/.vim/bundle
git clone git://github.com/borissov/fugitive-bitbucketserver
```

## Settings
In your vimrc file add options to set your bitbucket server urls.

```viml
let g:fugitive_bitbucketservers_domains = ['http://yoururl.com'] 
```
If your server URL includes a port as well as the hostname e.g. http://yoururl.com:7990 then just the hostname should be configured, don't include the ":7990".

### Originaly from
tommcdo/vim-fubitive
