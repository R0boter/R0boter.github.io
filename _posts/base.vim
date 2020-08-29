" =============================================================================
" Filename: spaceline.vim
" Author: glepnir
" URL: https://github.com/glepnir/spaceline.vim
" License: MIT License
" =============================================================================
"


function! spaceline#colorscheme_init()
  let l:theme = g:spaceline_colorscheme
  let colorstring ='call'.' '.'spaceline#colorscheme#'.l:theme.'#'.l:theme.'()'
  execute colorstring
endfunction


function! spaceline#setInActiveStatusLine()
    let &l:statusline=s:InActiveStatusLine()
    call spaceline#colorscheme_init()
endfunction

function! s:InActiveStatusLine()
    let s:statusline=""
    let s:statusline.="%#HomeMode#"
    let s:statusline.="%#HomeMode#%{spaceline#buffer#buffer()}"
    let s:statusline.="%#InActiveHomeRight#"
    let s:statusline.=g:sep.homemoderight
    let s:statusline.="%#InActiveFilename#"
    let s:statusline.="\ "
    let s:statusline.="%{spaceline#file#file_name()}"
    let s:statusline.="%="
    let s:statusline.="%#StatusLineinfo#%{spaceline#file#file_type()}"
    return s:statusline
endfunction

function! spaceline#spacelinetoggle()
	if get(g:,'loaded_spaceline',0) ==1
        " 调用设置 状态栏函数
    call s:SetStatusline()
  else
    let &l:statusline=''
  endif
endfunction

" 设置状态栏 根据情况启用不同状态栏
function! s:SetStatusline()"{{{
    " 判断文件类型 是否在列表中 这个列表是一些主流的文件管理器
    if index(g:spaceline_shortline_filetype, &filetype) >= 0
        " 如果在就调用 sort_statusline
      let &l:statusline=s:short_statusline()
      " 然后设置顔色
      call spaceline#colorscheme_init()
      return
    endif
    " 如果不是文件管理器就 作为活动 缓冲区 使用 ActiceStatusLine
    let &l:statusline=s:ActiveStatusLine()
    call spaceline#colorscheme_init()
endfunction"
"}}}
" 文件管理插件的状态栏
function! s:short_statusline() abort"{{{
    let s:statusline=""
    let s:statusline.="%#HomeMode#"
    let s:statusline.="%{spaceline#buffer#buffer()}"
    let s:statusline.="%#ShortRight#"
    let s:statusline.=g:sep.homemoderight
    let s:statusline.="%#emptySeperate1#"
    let s:statusline.="%="
    let s:statusline.="%#StatusLineinfo#"
    let s:statusline.="%{spaceline#file#file_type()}"
    return s:statusline
endfunction"
"}}}
" 当前活动 buffer 的状态栏
function! s:ActiveStatusLine()
    " 设置文件图标及顔色
    let file_icon = spaceline#syntax#icon_syntax()
    " 设置文件类型的图标字典
    if !exists('g:coldevicons_iconmap')     " Iconmap mapping colors to the Symbols [default unused symbols : , , ]{{{
        let g:coldevicons_iconmap = {
            \'Brown'        : [''],
            \'Aqua'         : [''],
            \'LightBlue'    : [''],
            \'Blue'         : ['','','','','','','','','','',''],
            \'Darkblue'     : ['',''],
            \'Purple'       : ['','','','','',''],
            \'Red'          : ['','','','','',''],
            \'Beige'        : ['','',''],
            \'Yellow'       : ['','','λ','',''],
            \'Orange'       : [''],
            \'Darkorange'   : ['','','','',''],
            \'Pink'         : ['',''],
            \'Salmon'       : [''],
            \'Green'        : ['','','','',''],
            \'Lightgreen'   : ['',''],
            \'White'        : ['','','','','','']
        \}
    endif"}}}
    function! spaceline#syntax#icon_syntax()"{{{
    " 先获取文件类型的图标，
         let icon = substitute(WebDevIconsGetFileTypeSymbol(), "\u00A0", '', '')
    " 获取 背景顔色
         let bg_color = substitute(synIDattr(hlID("FileName"), "bg"),'#','','')
    " 循环将文件类型图标字典中的key（一个顔色名）提取出来
         for color in keys(g:coldevicons_iconmap)
             " 判断文件类型图标是否在对应顔色的值的列表中
             let index = index(g:coldevicons_iconmap[color], icon)
             " 如果在 就设置高亮组 FileIcon+顔色名
             if index != -1
               execute 'highlight! FileIcon'.color.' guifg=#'.g:coldevicons_colormap[color].' ctermfg='.s:rgb(g:coldevicons_colormap[color]) . ' guibg=#' . bg_color
               break
             endif
         endfor
        " 返回一个 vim 状态栏格式的 配置好顔色的文件类型图标
        return '%#FileIcon'.color.'#' . ' %{WebDevIconsGetFileTypeSymbol()}'
    endfunction"}}}
    " 设置状态栏
    let s:statusline=""
    " 设置状态栏高亮组 由两个 # 号包裹高亮组名 .= 和 += 一个意思
    let s:statusline.="%#HomeMode#"
    let s:statusline.="\ "
    " 获取当前 vim 模式,并设置
    let s:statusline.="%{spaceline#vimode#vim_mode()}"
    " 根据当前模式返回对应的美化字符
     function! spaceline#vimode#vim_mode()"{{{
        let status= exists('g:spaceline_custom_vim_status') ? get(g:,'spaceline_custom_vim_status') : {"n": "🅝  ","V":"🅥  ","v":"🅥  ","\<C-v>": "🅥  ","i":"🅘  ","R":"🅡  ","s":"🅢  ","t":"🅣  ","c":"🅒  ","!":"SE "}
        return status[mode()]
    endfunction"}}}
    " 设置高亮组 HommeModeRight 
    let s:statusline.="%#HomeModeRight#"
    " 设置分割符
    let s:statusline.=g:sep.homemoderight"
    {{{" 先判断设定的 状态栏风格
    let g:seperate_style = get(g:, 'spaceline_seperate_style', 'slant')
    " 根据不同风格从 分割符列表中提取分割符
    let g:sep= {}
    let g:sep = spaceline#seperator#spacelineStyle(g:seperate_style)
    " 定义的获取分割符列表函数
    function! spaceline#seperator#spacelineStyle(style)"{{{
        let s:seperator={}
        if a:style == 'slant'
            let s:seperator.homemoderight = ''
            let s:seperator.filenameright = ''
            let s:seperator.filesizeright = ''
            let s:seperator.gitleft = ''
            let s:seperator.gitright = ''
            let s:seperator.lineinfoleft = ''
            let s:seperator.lineformatright = ''
            let s:seperator.EndSeperate = ' '
            let s:seperator.emptySeperate1 = ''
        elseif a:style == 'slant-cons'
            let s:seperator.homemoderight = ''
            let s:seperator.filenameright = ''
            let s:seperator.filesizeright = ''
            let s:seperator.gitleft = ''
            let s:seperator.gitright = ''
            let s:seperator.lineinfoleft = ''
            let s:seperator.lineformatright = ''
            let s:seperator.EndSeperate = ' '
            let s:seperator.emptySeperate1 = ''
        elseif a:style == 'slant-fade'
            let s:seperator.homemoderight = ''
            let s:seperator.filenameright = ''
            let s:seperator.filesizeright = ''
            let s:seperator.gitleft = ''
            let s:seperator.gitright = ''
            " let s:seperator.gitright = ''
            let s:seperator.lineinfoleft = ''
            let s:seperator.lineformatright = ''
            let s:seperator.EndSeperate = ' '
            let s:seperator.emptySeperate1 = ''
        elseif a:style == 'arrow-fade'
            let s:seperator.homemoderight = ''
            let s:seperator.filenameright = ''
            let s:seperator.filesizeright = ''
            let s:seperator.gitleft = ''
            let s:seperator.gitright = ''
            let s:seperator.lineinfoleft = ''
            let s:seperator.lineformatright = ''
            let s:seperator.EndSeperate = ' '
            let s:seperator.emptySeperate1 = ''
        elseif a:style == 'arrow'
            let s:seperator.homemoderight = ''
            let s:seperator.filenameright = ''
            let s:seperator.filesizeright = ''
            let s:seperator.gitleft = ''
            let s:seperator.gitright = ''
            let s:seperator.lineinfoleft = ''
            let s:seperator.lineformatright = ''
            let s:seperator.EndSeperate = ' '
            let s:seperator.emptySeperate1 = ''
        elseif a:style == 'curve'
            let s:seperator.homemoderight = ''
            let s:seperator.filenameright = ''
            let s:seperator.filesizeright = ''
            let s:seperator.gitleft = ''
            let s:seperator.gitright = ''
            let s:seperator.lineinfoleft = ''
            let s:seperator.lineformatright = ''
            let s:seperator.EndSeperate = ' '
            let s:seperator.emptySeperate1 = ''
        elseif a:style == 'none'
            let s:seperator.homemoderight = ''
            let s:seperator.filenameright = ''
            let s:seperator.filesizeright = ''
            let s:seperator.gitleft = ''
            let s:seperator.gitright = ''
            let s:seperator.lineinfoleft = ''
            let s:seperator.lineformatright = ''
            let s:seperator.EndSeperate = ' '
            let s:seperator.emptySeperate1 = ''
        endif
        return s:seperator
    endfunction"}}}}}}
    " 判断是否有文件名，有文件名则进行设置先扩展 %t
    " 为当前缓冲区文件名，判断文件名是否为空,为空就是没有文件名返回1然后取反，有文件名返回0
    " 取反进入设置状态栏
    if !empty(expand('%t'))
      " 和上面 fileicon 一样，返回的是一个 vim
      " 状态栏格式的设置好颜色的文件类型图标
      let s:statusline.=spaceline#syntax#icon_syntax()
      " 设置高亮组 FileName
      let s:statusline.="%#FileName#"
      let s:statusline.="\ "
      " 获取文件名
      let s:statusline.="%{spaceline#file#file_name()}"
      " 获取文件名的函数
      function! spaceline#file#file_name() abort"{{{
        " 判断是不是没有文件名，或者是否是 文件管理插件 的文件名.是这两种就返回空
        if empty(expand('%:t')) || index(g:spaceline_shortline_filetype, &filetype) >= 0
          return ''
        endif
        " 获取当前文件状态（是否被修改）
        let mo = s:file_is_modified()
            " 获取文件是否已经修改或是否可以修改
            function! s:file_is_modified() abort"{{{
                " 先检查文件类型和终端类型，任意一个函数返回true就返回空，在下面判断
                return spaceline#utils#line_is_lean() || spaceline#utils#line_is_plain() ?  ''  :
                " 如果缓冲区已经被修改，则使用后面的 pen
                " 图标,如果没有修改则进入后面判断
                            \ &modified                                       ?  ' ' :
                " 缓冲区是否可以被修改，可以则返回空，不可以返回_
                            \ &modifiable                                     ?  ''  : ' -'
            endfunction"}}}
 " 判断文件类型是否是 文件管理插件或者处于比较模式 是就返回true
                function! spaceline#utils#line_is_lean() abort"{{{
                    return &filetype =~? '\v^defx|dbui|chadtree|mundo(diff)?$'
                endfunction"}}}
 " 判断当前 buffer 是否是终端类型 或者 文件类型是否是 文件管理插件 类型，是两种任意一种就返回 true
                function! spaceline#utils#line_is_plain() abort"{{{
                    return &buftype ==? 'terminal' || &filetype =~? '\v^help|denite|dbui|defx|chadtree|coc-explorer|vim-plug|nerdtree|vista_kind|vista|magit|tagbar$'
                endfunction"}}}
        " 
        let fname = s:current_file_name()
            " 获取当前文件名
            function! s:current_file_name()"{{{
                " 判断是否是只读文件，是只读文件但不是帮助文件就返回
                " 锁图标，否则返回空
              return ('' != s:file_readonly() ? s:file_readonly() . ' ' : '') .
                    \ ('' != expand('%:t') ? expand('%:t') : '')
              
                     " 判断文件是否是只读文件             
                         function! s:file_readonly()"{{{
                             " 如果文件 是帮助文件就返回空
                           if &filetype == "help"
                             return ""
                             " 如果不是帮助文件，判断是否是只读文件
                           elseif &readonly
                             return ""
                             " 如果不是帮助文件也不是只读文件则返回空
                           else
                             return ""
                           endif
                         endfunction"}}}
            endfunction"}}}
        " 判断文件是否修改，没有就只返回文件名，修改了就返回文件名和修改状态图标
        if empty(mo)"
          return fname
        else
          return fname. ''.mo
        endif
      endfunction"}}}
      let s:statusline.="\ "
      " 设置文件名右边的高亮组
      let s:statusline.="%#FileNameRight#"
      " 获取分隔符
      let s:statusline.=g:sep.filenameright
    endif

    " 获取当前屏幕的一半宽度
    let squeeze_width = winwidth(0) / 2
    " 诊断工具发送的错误信息或警告信息存在，且窗口的宽度大于80,就显示报错信息
    if !empty(spaceline#diagnostic#diagnostic_error())|| !empty(spaceline#diagnostic#diagnostic_warn()) && squeeze_width >40
        " 获取诊断工具发出的错误信息
        function! spaceline#diagnostic#diagnostic_error()"{{{
              let l:error_message = s:diagnostic_{g:spaceline_diagnostic}_error()
              " 我使用的Coc所以用Coc来分析获取错误信息数
                    function! s:diagnostic_coc_error()"{{{}}}{{{
                        " 获取信息
                        let info = get(b:, 'coc_diagnostic_info', {})
                        " 判断 是否为空
                        if empty(info)
                            return ''
                        endif
                        " 设置一个空列表，准备存放，错误图标和信息
                        let errmsgs = []
                        " 判断获取的信息里error有没有值,有就取他的值和图标拼接
                        " Coc中的诊断信息以键值对方式存放的，值就是键的个数
                        if get(info, 'error', 0)
                            call add(errmsgs, g:spaceline_errorsign . info['error'])
                        endif
                        " 拼接这个列表
                        return join(errmsgs, ' ')
                    endfunction"}}}
              return l:error_message
        endfunction"}}}
        " 获取诊断工具发出的警告信息,同错误信息同理就不详细分析了
        function! spaceline#diagnostic#diagnostic_warn()"{{{
            let l:warn_message = s:diagnostic_{g:spaceline_diagnostic}_warn()
                function! s:diagnostic_coc_warn() abort
                      let info = get(b:, 'coc_diagnostic_info', {})
                      if empty(info)
                        return ''
                      endif
                      let warnmsgs = []
                    if get(info, 'warning', 0)
                        call add(warnmsgs, g:spaceline_warnsign . info['warning'])
                    endif
                    return join(warnmsgs, ' ')
                endfunction
            return l:warn_message
        endfunction"}}}
        " 设置错误高亮组
        let s:statusline.="%#CocError#"
        let s:statusline.="\ "
        " 获取错误信息
        let s:statusline.="%{spaceline#diagnostic#diagnostic_error()}"
        let s:statusline.="\ "
        " 设置警告高亮组
        let s:statusline.="%#CocWarn#"
        " 获取警告信息
        let s:statusline.="%{spaceline#diagnostic#diagnostic_warn()}"
        let s:statusline.="\ "
        " 判断 是否有文件大小，且窗口宽度大于80
    elseif !empty(spaceline#file#file_size()) && squeeze_width > 40
        " 获取ok符号和文件大小
        function! spaceline#file#file_size()abort"{{{
              if empty(expand('%:t'))
                return ''
              endif
              let l:oksign = spaceline#diagnostic#diagnostic_ok()

                    function! spaceline#diagnostic#diagnostic_ok()"{{{
                        " 获取返回的 ok 信息，
                          let l:ok_message = s:diagnostic_{g:spaceline_diagnostic}_ok()
                         " 通过诊断信息，如果没有报错也没有警告则显示之前定义的ok符号
                                 function! s:diagnostic_coc_ok()"{{{
                                      let info = get(b:, 'coc_diagnostic_info', {})
                                      if empty(info)
                                        return g:spaceline_oksign
                            " 之前定义的 oksig 符号{{{
                       let g:spaceline_oksign = get(g:,'spaceline_diagnostic_oksign', '')"}}}
                                      elseif info['warning'] == 0 && info['error'] ==0
                                        return g:spaceline_oksign
                                      endif
                                endfunction"}}}
                          return l:ok_message
                    endfunction"}}}
            " 额，他这里用的寄存器 % 寄存器中存放的当前文件的文件名
              return ' '.l:oksign.'  '.s:size(@%)
              " 获取文件当前文件的文件大小
                        function! s:size(f) abort"{{{
                            " 目录返回 0 找不到返回 -1 过大返回 -2
                            let l:size = getfsize(expand(a:f))
                          if l:size == 0 || l:size == -1 || l:size == -2
                            return ''
                          endif
                          " 获取到数值则进行换算，然后添加单位
                          if l:size < 1024
                            let size = l:size.'b'
                          elseif l:size < 1024*1024
                            let size = printf('%.1f', l:size/1024.0).'k'
                          elseif l:size < 1024*1024*1024
                            let size = printf('%.1f', l:size/1024.0/1024.0) . 'm'
                          else
                            let size = printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g'
                          endif
                          return size
                        endfunction"}}}
        endfunction"}}}
        " 设置文件大小高亮组
        let s:statusline.="%#Filesize#"
        " 设置ok 符号和文件大小
        let s:statusline.="%{spaceline#file#file_size()}"
        let s:statusline.="\ "
    endif
    " 判断是否是版本管理库
    if !empty(spaceline#vcs#git_branch())
        " 
            function! spaceline#vcs#git_branch() abort 
                if get(b:, 'gitbranch_pwd', '') !=# expand('%:p:h') || !has_key(b:, 'gitbranch_path')
                    call spaceline#vcs#gitbranch_detect(expand('%:p:h'))
                endif
                if has_key(b:, 'gitbranch_path') && filereadable(b:gitbranch_path)
                    let branch = get(readfile(b:gitbranch_path), 0, '')
                    if branch =~# '^ref: '
                        return ' '. substitute(branch, '^ref: \%(refs/\%(heads/\|remotes/\|tags/\)\=\)\=', '', '')
                    elseif branch =~# '^\x\{20\}'
                        return ' '. branch[:6]
                    endif
                endif
                return ''
            endfunction
        let s:statusline.="%#GitLeft#"
        let s:statusline.=g:sep.gitleft
        let s:statusline.="%#GitBranchIcon#"
        let s:statusline.="\ "
        let s:statusline.="%{spaceline#vcs#git_branch_icon()}"
        let s:statusline.="%#GitInfo#"
        let s:statusline.="%{spaceline#vcs#git_branch()}"
        let s:statusline.="\ "
        if !empty(spaceline#vcs#diff_add())
          let s:statusline.="%#GitAdd#"
          let s:statusline.= "%{spaceline#vcs#diff_add()}"
        endif
        if !empty(spaceline#vcs#diff_remove())
          let s:statusline.="%#GitRemove#"
          let s:statusline.= "%{spaceline#vcs#diff_remove()}"
        endif
        if !empty(spaceline#vcs#diff_modified())
          let s:statusline.="%#GitModified#"
          let s:statusline.= "%{spaceline#vcs#diff_modified()}"
        endif
        let s:statusline.="%#GitRight#"
        let s:statusline.=g:sep.gitright
    endif
    if !empty(expand('%:t')) && empty(spaceline#vcs#git_branch()) && &filetype != 'defx'&& &filetype!='chadtree' && &filetype != 'coc-explorer' && &filetype != 'debui'
        let s:statusline.="%#emptySeperate1#"
        let s:statusline.=g:sep.emptySeperate1
    endif
    if empty(expand('%:t')) && empty(spaceline#vcs#git_branch())
        let s:statusline.="%#emptySeperate1#"
        let s:statusline.=g:sep.emptySeperate1
    endif
    let s:statusline.="%#CocBar#"
    let s:statusline.="\ "
    let s:statusline.="%{spaceline#status#coc_status()}"
    let s:statusline.="%="
    if squeeze_width >40
      let s:statusline.="%#VistaNearest#"
      let s:statusline.="%{spaceline#vista#vista_nearest()}"
    endif
    let s:statusline.="%#LineInfoLeft#"
    let s:statusline.=g:sep.lineinfoleft
    if squeeze_width > 40
      let s:statusline.="%#StatusEncod#"
      let s:statusline.="\ "
      let s:statusline.="%{spaceline#file#file_encode()}"
      let s:statusline.="\ "
      let s:statusline.="%#StatusFileFormat#%{spaceline#file#file_format()}"
    endif
    let s:statusline.="%#LineFormatRight#"
    let s:statusline.=g:sep.lineformatright
    let s:statusline.="%#StatusLineinfo#%{spaceline#file#file_type()}"
    let s:statusline.="%#EndSeperate#"
    let s:statusline.="%{spaceline#scrollbar#scrollbar_instance()}"
    return s:statusline
endfunction

