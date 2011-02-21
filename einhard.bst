ENTRY {
  address
  editor
  author
  edition
  lastchecked
  publisher
  series
  title
  url
  volume
  year
}
{}
{}

STRINGS { h s t u v w }
STRINGS { fkt }

INTEGERS { nameptr namesleft numnames }
INTEGERS { zahl  lang }
INTEGERS { ptr collation collrest }

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {output} {
  duplicate$ empty$
    { pop$ }
    { "{" swap$ * "}" * write$ }
  if$
}

FUNCTION {output.space} {
  "{ }" write$
}

FUNCTION {output.comma} {
  "{, }" write$
}

FUNCTION {output.colon} {
  "{: }" write$
}

FUNCTION {output.period} {
  "{. }" write$
}

FUNCTION {output.semicolon} {
  "{; }" write$
}

FUNCTION {begin.entry} {
  newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
}

FUNCTION {format.names}
{ 's :=
  "" 'u  :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    {
       s nameptr "{ll}" format.name$ 't :=
       s nameptr "{ jj}" format.name$ 'w :=
       s nameptr "{, ff}{ vv}{ jj}" format.name$ 'u :=
       u  text.length$  'lang :=
       #1 'zahl :=
       "" 'v :=
         {  zahl  lang  <  }
         {  u  zahl  #1  substring$  "~"  =
               {  v  ""  =
                     {  u  #1  zahl  #1  -  substring$  'v :=  }
                     'skip$
                  if$
                  v  u  zahl  #2  substring$ * "." *  w * 'v :=
               }
               'skip$
            if$
            zahl  #1  +  'zahl :=  }
      while$
      v  ""  =
         {  u  'v :=  }
         'skip$
      if$
      t  v  *  fkt  *  't :=
      nameptr #1 >
         { namesleft #1 >
             { "; " * t * }
             { numnames #2 >
                  { "" * }
                  'skip$
               if$
               t "others" = t "others (Hrsg.)" = or
                  { " u.a." * }
                  { "; " * t * }
               if$
               }
            if$  %% Ende der namesleft-Pruefung
          }
            't
           if$  %%  Ende der nameptr-Pruefung

      nameptr #1 + 'nameptr :=
      namesleft #1 -  'namesleft :=
    }
  while$  %%  Ende von { namesleft #0 > } ganz oben
  "" 'fkt :=  %% fkt wird zurueckgesetzt
}

FUNCTION {format.authors} {
  author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors} {
  editor empty$
    { "" }
    { " (Hrsg.)" 'fkt :=
      editor format.names }
  if$
}

FUNCTION {format.title} {
  title empty$
    { "" }
    { "\em{" title * "}" * }
  if$
}

FUNCTION {format.year} {
  year empty$
    { "o.J." }
    { year }
  if$
}

FUNCTION {format.address} {
  address empty$
    { "o.O." }
    { address }
  if$
}

FUNCTION {format.publisher} {
  publisher empty$
    { "" }
    { "(" publisher * ")" * }
  if$
}

FUNCTION {format.edition} {
  edition empty$
    { "" }
    { "$^{" edition * "}$" * }
  if$
}

FUNCTION {format.series} {
  series empty$
    { "" }
    { "\em{" series * "}" * }
  if$
}

FUNCTION {format.volume} {
  volume empty$
    { "" }
    { "(Band " volume * ")" * }
  if$
}

FUNCTION {format.url} {
  url empty$
    { "\em{URL fehlt}" }
    { "\url{" url * "}" * }
  if$
}

FUNCTION {format.lastchecked} {
  lastchecked empty$
    { "" }
    { "(" lastchecked * ")" * }
  if$
}

FUNCTION {format.website.title} {
  title empty$
    {}
    { "``" title * "''" * }
  if$
}

FUNCTION {book} {
  begin.entry

  format.authors output
  format.authors empty$
    { }
    {
      format.editors empty$
	{ output.comma }
	{ output.semicolon }
      if$
    }
  if$

  format.editors output
  format.editors empty$
    { }
    { output.comma }
  if$

  format.series output
  format.series empty$
    { }
    {
      output.space
      format.volume output
      output.colon
    }
  if$

  format.title output
  output.comma

  format.address output
  output.space

  format.year output
  format.edition output
  output.space

  format.publisher output

  output.period
}

FUNCTION {website} {
  begin.entry

  format.authors output
  format.authors empty$
    {}
    { output.comma }
  if$

  format.website.title output

  output.space
  "unter:" output
  output.space

  format.url output

  output.space
  format.lastchecked output
}

FUNCTION {begin.bib} {
  "\begin{thebibliography}{9999}" write$ newline$
}

FUNCTION {end.bib} {
  "\end{thebibliography}" write$ newline$
  "\endinput" write$ newline$
}

READ
SORT
EXECUTE {begin.bib}
ITERATE {call.type$}
EXECUTE {end.bib}