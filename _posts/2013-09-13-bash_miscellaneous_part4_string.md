---
title:      bash 拾零， part 4 - 字符串
category:   blog
layout:     post
tags:       [bash, shell]
---



# 字符串截取

基本方法参见下面的代码：

    name='caoxudong'
    echo ${name:0:2}
	echo ${name:2:2}
	echo ${name:-1:2}
	echo ${name:-100:2}

输出为：

    ca
    ox
    caoxudong
    caoxudong

man中写道：

    DEFINITIONS

        The following definitions are used throughout the rest of this document.
        blank  A space or tab.
        word   A sequence of characters considered as a single unit by the shell.  Also known as a  token.
        name   A  word  consisting  only of alphanumeric characters and underscores, and beginning with an
               alphabetic character or an underscore.  Also referred to as an identifier.
        metacharacter
               A character that, when unquoted, separates words.  One of the following:
               |  & ; ( ) < > space tab
        control operator
               A token that performs a control function.  It is one of the following symbols:
               || & && ; ;; ( ) | <newline>

    PARAMETERS
    
        A parameter is an entity that stores values.  It can be a name, a number, or one  of  the  special
        characters listed below under Special Parameters.  A variable is a parameter denoted by a name.  A
        variable has a value and zero or more attributes.   Attributes  are  assigned  using  the  declare
        builtin command (see declare below in SHELL BUILTIN COMMANDS).

    ${parameter:offset:length}
    
        Substring Expansion.  Expands to up to length characters of parameter starting at the char-
        acter specified by offset.  If length is omitted, expands to  the  substring  of  parameter
        starting  at  the  character specified by offset.  length and offset are arithmetic expres-
        sions (see ARITHMETIC EVALUATION below).  length must evaluate to a number greater than  or
        equal  to  zero.   If  offset evaluates to a number less than zero, the value is used as an
        offset from the end of the value of parameter.  If parameter is @,  the  result  is  length
        positional  parameters  beginning at offset.  If parameter is an array name indexed by @ or
        *, the result is the length members of the array beginning  with  ${parameter[offset]}.   A
        negative  offset  is  taken relative to one greater than the maximum index of the specified
        array.  Note that a negative offset must be separated from the colon by at least one  space
        to avoid being confused with the :- expansion.  Substring indexing is zero-based unless the
        positional parameters are used, in which case the indexing starts at 1.
