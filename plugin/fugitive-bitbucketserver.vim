function! s:function(name) abort
  return function(substitute(a:name,'^s:',matchstr(expand('<sfile>'), '<SNR>\d\+_'),''))
endfunction

function! s:bitbucketserver_url(opts, ...) abort
  if a:0 || type(a:opts) != type({})
    return ''
  endif
  let path = substitute(a:opts.path, '^/', '', '')
  let domain_pattern = 'bitbucket\.org'
  let domains = exists('g:fugitive_bitbucketservers_domains') ? g:fugitive_bitbucketservers_domains : []
  for domain in domains
    let domain_pattern .= '\|' . escape(split(domain, '://')[-1], '.')
  endfor
  let repo = matchstr(a:opts.remote,'^\%(https\=://\|git://\|\(ssh://\)\=git@\)\%(.\{-\}@\)\=\zs\('.domain_pattern.'\)[/:].\{-\}\ze\%(\.git\)\=$')
  if repo ==# ''
    return ''
  endif
  if index(domains, 'http://' . matchstr(repo, '^[^:/]*')) >= 0
    let root = 'http://' . repo
  else
    let root = 'https://' . repo
  endif
  let reponame = split(root,'/')[-1]
  let cursor_pos = getpos(".")
  let root = substitute(root,reponame,'repos/'.reponame,'')
  let root = substitute(root,'/scm/','/projects/','')
  if path =~# '^\.git/refs/heads/'
    return root . '/commits/'.path[16:-1]
  elseif path =~# '^\.git/refs/tags/'
    return root . '/browse/'.path[15:-1]
  elseif path =~# '.git/\%(config$\|hooks\>\)'
    return root . '/admin'
  elseif path =~# '^\.git\>'
    return root
  endif
  if a:opts.commit =~# '^\d\=$'
    let commit = a:opts.repo.rev_parse('HEAD')
  else
    let commit = a:opts.commit
  endif
  if get(a:opts, 'type', '') ==# 'tree' || a:opts.path =~# '/$'
    return ''
  elseif get(a:opts, 'type', '') ==# 'blob' || a:opts.path =~# '[^/]$'
    let url = root . '/browse/'.path.'?until='.commit
    if get(a:opts, 'line1')
      let url .= '\#' . a:opts.line1
      if get(a:opts, 'line2')
        let url .= '-' . a:opts.line2
      endif
    endif
  else
    let url = root . '/commits/' . commit
  endif
  return url
endfunction

if !exists('g:fugitive_browse_handlers')
  let g:fugitive_browse_handlers = []
endif

call insert(g:fugitive_browse_handlers, s:function('s:bitbucketserver_url'))
