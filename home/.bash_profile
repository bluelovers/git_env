
# utf-8 確認可在 cherry-pick 時保有中文訊息
export LESSCHARSET=utf-8

#export LESSCHARSET=iso8859

#export LC_ALL=zh_CN.GBK
#export LC_CTYPE=zh_CN.GBK
#export LANG=zh_CN.GBK
#export OUTPUT_CHARSET="GBK"
#
#stty cs8 -istrip
#stty pass8
#export LESSCHARSET=GBK

# 讓ls和dir命令顯示中文和顏色
alias ls='ls --show-control-chars --color'
alias dir='dir -N --color'
alias less='less -r'
## 設置為中文環境，使提示成為中文
#export LANG="zh_CN.GBK"
## 輸出為中文編碼
#export OUTPUT_CHARSET="GBK"

export LANG="zh_TW.UTF-8"
export OUTPUT_CHARSET="zh_TW.UTF-8"

export LC_ALL="zh_TW.UTF-8"
export LC_CTYPE="zh_TW.UTF-8"
