all arg: (discord arg) (facebook arg) (instagram arg) (full_hd arg)


discord arg:  
  typst compile main.typ --format png --ppi 80 --input cfg={{arg}}/config.yaml --input layout=layouts/discord.yaml {{arg}}/discord.png

facebook arg:  
  typst compile main.typ --format png --ppi 144 --input cfg={{arg}}/config.yaml --input layout=layouts/facebook.yaml {{arg}}/facebook.png

instagram arg:  
  typst compile main.typ --format png --ppi 108 --input cfg={{arg}}/config.yaml --input layout=layouts/instagram.yaml {{arg}}/instagram.png

full_hd arg:  
  typst compile main.typ --format png --ppi 192 --input cfg={{arg}}/config.yaml --input layout=layouts/full_hd.yaml {{arg}}/full_hd.png
