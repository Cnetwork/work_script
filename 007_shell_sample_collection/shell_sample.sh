#!/bin/bash -v

#  A shell sample for beginner, start each file with a description of its contents.
#+ https://google.github.io/styleguide/shell.xml?showone=File_Header#File_Header

export PATH=$PATH:'/usr/yidian/bin:/usr/bin:/opt/yidian/bin:/opt/yidian'
export SHELL_SAMPLE_LOG="shell_sample.log"

#  All error messages should go to STDERR
#+ A function to print out error messages alone with other status information is recommonded
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] : $@" >&2
}

#  All function comments should contain: 1. Description; 2. Global variables;
#+ 3. Arguments taken; 4. Return values & default exit status.
#######################################
# Cleanup files from the backup dir
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
# Returns:
#   None
#######################################
cleanup() {
  echo "Clean up process" | tee -a ${SHELL_SAMPLE_LOG}
}

#  Don't comments everthing. If there's a complex algorithm or you're doing
#+ something out of the oridinary, put a short comment in.
#+ Use #+ to comment multiline comments.
echo "Hello, Yidian World!" | tee -a ${SHELL_SAMPLE_LOG}

#  Use this type comment to description a error.
#+ Replacing line 7, above, with
#+   cat > $Newfile <<End-of-message
#+       ^^^^^^^^^^
#+ writes the output to the file $Newfile, rather than to stdout.

#  TODOs should include string TODo in all caps, followed by your username in parentheses. A colon(:) is optional.
#+ It's preferable to put a bug/ticket number next to the TODo item as well.
#+ TODO(cnetwork) : Handle the unlikely edege case (bug ####)

# Maximum line length is 80 characters. if more than 80, use "here document" or an embedded newline if possible.
cat <<-delimiter
  Here is the Document.
  A here document is a Special-purpose code block.
  It uses a form of I/O redirection to feed a command
  list to an interactive program or a command,
  such as ftp, cat or the ex text editor.
  http://tldp.org/LDP/abs/html/here-docs.html
delimiter

#  Embedded newlines are ok too
long_string="I am an exceptionally
  long string."
echo ${long_string} | tee ${SHELL_SAMPLE_LOG}

#  Pipelines should be split one per line if they don't all fit on one line.
ifconfig | grep "inet"

#  If not, it should be split at one pipe segment per line with the pipe on the newline
#+ and a 2 space indent for the next section of the pipe. This applies to a chain of
#+ commands combined with '|' as wel as to logical compounds using '||' and '&&'.
ifconfig \
  | grep "inet" \
  | grep -v "inet6" \
  | awk '{print "Local ip is : "$2}' \
  | tee ${SHELL_SAMPLE_LOG}

#  Loops put ; do and ; then on the same line as the while, for or if.
#+ for   ; do   done
#+ if    ; then fi
#+ while ; do   done
file_list=`ls -al ./ | awk '{print $9}'`
for dir_file in ${file_list}; do
    echo "current directory contain : "${dir_file} | tee ${SHELL_SAMPLE_LOG}
done

#  循环 lt 是小于的意思
while_mark=0
while [ ${while_mark} -lt 1000 ] ; do
    ((while_mark++))
done
echo "loop \$while_mark -lt 1000 result : "${while_mark} | tee ${SHELL_SAMPLE_LOG}

#  Case statement
#+ case word in [ [(] pattern [| pattern]…) command-list ;;]… esac
#+ 1. Indent alternatives by 2 spaces.
#+ 2. A one-line needs a space after the close parenthesis ) of the pattern and before ;;
#+ 3. Long or multi-command alternatives should be split over multiple lines with pattern
#++ actions, and ;; on the separate lines.
#+ https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html
echo -n "Enter the name of an animal: "
read ANIMAL
echo -n "The ${ANIMAL} has "
case "$ANIMAL" in
  horse | dog | cat)  echo -n "four" ;;
  man | kangaroo )
    echo -n "two"
    another_command "${actions}" "${other_expr}" ...
    ;;
  *)
    error "Unexpected expression '${expression}'"
    ;;
esac
echo " legs"

#  Section of recommanded variable expansion cases.
#+ 1. Stay consistent with what you find for existing code
#+ 2. Quote variables (Single character is special, if no confusion, don't brace-quote it)
#+ 3. Prefer brace-quoting all other variables.

echo "Specials: !=$!, -=$-, _=$_. ?=$?, #=$# *=$* @=$@ \$=$$ ..." \
  | tee -a ${SHELL_SAMPLE_LOG}

# Braces necessary
echo "many parameters: ${10}"

# Braces avoiding confusion:
# Out put is "a0b0c0"
set -- a b c
echo "${1}0${2}0${3}0"

# Preferred sytle for other variables:
echo "PATH=${PATH}, PWD=${PWD}, mine=${some_var}"


#  Quoting
#+ Always quoting strings containing variables, command substitutions, spaces or shell
#++ meta characters, unless careful unquoted expansion is required.
#+ Prefer quoting strings that are "words" (as opposed to command options or path names)
#+ Never quote literal integers.
#+ Be aware of quoting rules for pattern matches in [[.
#+ Use "$@" unless you have a specific reason to use $*.

# 'Single' quote indicate that no substitution is desired.
# "Double" quote indicate that substitution is required/tolerated.

# "quote command substitutions"
flas="$(some_command and its args "$@" 'quoted sparately')"

# "quote variables"
echo "${flag}"

# "never quote literal integers"
value=32

# "quote command substitutions", even when you expect integers
number="$(generate_number)"

# "prefer quoting words", not compulsory(不强制)
readonly USE_INTEGER='true'

# "quote shell meta characters"
echo 'Hello stranger, and well met. Earn lots of $$$'
echo "Process $$: Done making \$\$\$."

# Don't quote command option or path names
# grep -li Hugo /dev/null "$1"

# "quote variables, unless proven false": ccs might be empty
# grep -cP '([sS]pecial\|?characters*)$' ${1:+"$1"}

# Features and Bugs

# Use $(command) instead of backticks(撇号`).
var=$(echo "$(echo "666")")

# Test, [ and [[, [[ ... ]] is preferred over [. test and /usr/bin[.
if [[ 'filename' =~ ^[[:alnum:]]+name ]]; then
  echo "Match"
fi

# This matches the exact pattern "f*" (Does not match in this case)
# If use regex pattern, do not use quote
if [[ 'filename' =~ "f.*" ]]; then
  echo 'Match f.*'
fi

# Not quote or use no quote variable
regex="f.*"
if [[ 'filename' =~ $regex ]]; then
  echo 'Match f.*'
fi

#  Testing Strings
#+ Bash is mart enough to deal with an emtpy string in a test. So, given that code is
#+ much easier to read.

# Use this type to test oridinary string and empty string
if [[ "$i" = "some_string" ]]; then
  echo "do_something"
fi

# Do not use a test string with an x behind.
if [[ -z "${my_var}" ]]; then
  echo "is empty"
fi

if [[ ! -n "${my_var}" ]]; then
  echo "is empty"
fi

#  Use an explicit path when doing wildcard expansion of filenames.
#+ It's a lot safer to expand wildcards with ./* instead of *.

#  Eval should be avoided.
#+ Didn't know what will eval set and will it succeed.
#+ What happens if one of the returned values has a space in it?
# variable="$(eval some_function)"

# Naming Conventions
# Function names is lower-case, with underscores to separate words.
# The keyword function is optional, but must be used consistently throughout a project.
my_func() {
  echo "my_func"
}

#  Constants and environment variable names should be all caps, separate with underscores.
#+ Declared at the top of the file.

# Constant
readonly PATH_TO_FILES='/some/path'
# Both constant and environment
declare -xr ORACLE_SID="PROD"

# Source filename is same as function name, lowercase with underscores to separate.
# maketemplate or make_template not make-template

# Use readonly or declare -r to ensure read-only variables.
zip_version="$(dpkg --status zip | grep Version: | cut -d ' ' -f 2)"
if [[ -z "${zip_version}" ]]; then
  error_message
else
  readonly zip_version
fi



# 求幂运算
let i=i**2
echo $i

((i=i**2))
echo $i

# 一种新的思想，将需要计算的值传给另一个命令
# scale 限定精度， 也可以通过 bc -l 不过是默认精度20位了
echo "scale=3; 1/13" | bc

# 将需要计算的值传给 awk
echo "1 13" | awk '{printf("%0.3f\n", $1/$2)}'

# && 的含义只有在左边命令为真的时候（成功执行）右边的命令才能被执行
[ $# -lt 1 ] && echo "please input the income file" && exit -1

# ;间隔，执行效果相当于多个独立命令单独执行
echo $1; echo $#; echo $!;

# 文件彻底置空，无内容且无大小
: > $1
> $1
cat /dev/null > $1

# RANDOM 产生 0到32767 的随机数 32768 = 128 * 128 * 2
for i in $(seq 1 10)
do
    echo $i $(($RANDOM/8192+3)) $((RANDOM/10+3000)) >> $1
done

# -s $1 代表存在（不为空），！将它取反，所以成功执行时候是不是文件的时候
[ ! -f $1 ] && echo "$1 is not a file" && exit -1

income=$1

# sort -k 2 代表对第二列排序， -n 是按照数字排序， -r 是按照递减顺序排序
awk '{
    printf("%d %0.2f\n", $1, $3/$2)
}' $income | sort -k 2 -n -r

# 生成一个0-255的数字，可以用awk扩大范围也可以用$RANDOM缩小范
expr $RANDOM/128
# 注意 echo ... | awk 的这种使用模式比较好
echo "" | awk '{printf("%d\n", rand()*255)}'

sh ./other_sample/getip.sh


# QUESTION,到底括号里加不加$
echo $((i+3))

echo ""
echo "-------------------------a------------------------"
echo `seq 5`
# -w 等宽 -s 连接符
echo `seq -s : 1 2 5`
echo `seq -w 1 2 14`
# -f --format
echo `seq -f "0x%g" 1 5`
# %1.f 可以显示大整数， %g 则将大整数显示为 e+06的形式
for i in `seq -f "http://book.zongheng.com/chapter/672340/%1.f.html" 36913207 36913211`;
do
#   wget $i
    echo $i
done
echo "-------------------------a------------------------"
echo ""

# 统计出现频率最高的10个单词
#curl  -o ./other_sample/newcomments "https://news.ycombinator.com/newcomments"
# mac中 sed换行符与普通操作系统不一致，用了 \'$'\n''的形式
# grep -v ^$ 是选择开头不为空的行, ^在shell中意味着开始，$是结尾
# uniq -c 是统计频次  sort -n 是按数字排序 -k 是第几列（field）-r 是逆向输出 reverse, 这样最大的在最前面
cat ./other_sample/newcomments | sed -e 's/[^a-zA-Z]/\'$'\n''/g' | grep -v ^$ | sort | uniq -c | sort -n -k 1 -r | head -10

if !(true && true) || false; then
    echo "yes"
else
    echo "no"
fi

# $? 用于存放上一次进程的结束状态
# 下面的一句话可以实现 if else 的过程，较为简洁
# !([ $# -gt 1 ] && echo "success") && echo "failed" && exit -1

if test 5 -eq 5; then echo "YES"; else echo "NO"; fi
if test 5 -ne 5; then echo "YES"; else echo "NO"; fi
if test -n "not empty"; then echo "YES"; else echo "NO"; fi
if test -z "not empty"; then echo "YES"; else echo "NO"; fi
if test -z ''; then echo "YES"; else echo "NO"; fi
if test -n ""; then echo "YES"; else echo "NO"; fi
# -f 是否是一个文件
if test -f /etc/zshrc; then echo "YES"; else echo "NO"; fi
# -d 是否是一个文件夹
if test -d /etc; then echo "YES"; else echo "NO"; fi
# -s 文件存在且文件大小大于零 文件夹恒为true
if test -s /etc; then echo "YES"; else echo "NO"; fi
mkdir ./other_sample/aaa
touch ./other_sample/bbb
if test -s ./other_sample/aaa; then echo "YES"; else echo "NO"; fi
if test -s ./other_sample/bbb; then echo "YES"; else echo "NO"; fi
# -e 是文件存在即为true
if test -e ./other_sample/bbb; then echo "YES"; else echo "NO"; fi
# -a 与 &&； -o 与 || , !test 与 test !
# test 与 [  ] 可以替代，但是注意[ 和] 右左需要加上额外的空格
# 字符串变量加上“”，防止变量为空的时候没有测试内容的情况
str="test"
if [ "$str" = "test" ]; then
    echo "YES";
else
    echo "NO";
fi

i=5
j=838709756203975230948

# echo .. | grep -q  配合上 $? 的做法，成功返回0，可以降低grep的搜索消耗，不展示搜索结果
ic="2398jf0298dgh29rjif209DU"
echo $ic | grep -q "^[0-9a-zA-Z]\+$" && echo "success"

echo "test2018@cnetwork.com" | grep -q "[0-9a-zA-Z\.]*@[0-9a-zA-Z\.]*"
echo $?

echo "http://news.lzu.edu.cn/article.jsp?newsid=10135" | grep -q "^http://[a-z0-9A-Z\./=?]\+$"
echo $?

# /dev/null 与 /dev/zero 是两个垃圾桶，后者还可以一直取到0，知道退出
# grep , sed, awk 都可以用到模式匹配
# test -z 可以判断字符串是否为空
kong=''
[ -z $kong ] && echo "kong is empty"

var="get the length of me"
echo ${var}
echo ${#var}
#expr length "$var"
#echo $var | awk '{printf("%d\n", length($0));}'
echo -n $var | wc -c
echo -n $var | wc -c

# 这个地方有点问题，统计特定单词个数
echo $var | wc -w
echo -n $var | sed -e 's/[^g]//g' | wc -c
echo -n $var | sed -e 's/[^gt]//g' | wc -c
echo -n $var | tr -cd g | wc -c

# 统计单词个数
echo "统计单词个数了"
echo $var | wc -w
echo "$var" | tr " " "\n" | grep get | uniq -c
echo "$var" | tr " " "\n" | grep get | wc -l

# 不知道为什么出错
#echo -e '\033[31;40m Hello World!'
for n in $(seq 1 2 10)
do
    echo "Hello World"
#    echo -e '\033[11;29H '$(date "+%Y-%m-%d %H:%M%S");
done

# bash提供数据结构, cut awk 提供了非常好的单行处理能力
# 将字符串存在数组中，数组是（）中加入由空格隔开的单词
var_arr=($var)
echo ${var_arr[1]} ${var_arr[4]}
# var_arr[@] 指的是整个数组
echo ${var_arr[@]}
# 可以用#来计算字符串长度
echo ${#var_arr[@]}

var_arr[5]="new_element"
echo ${#var_arr[@]}

# 数组还提供了类似的数组功能，对于空格分割的字符串, 不要用sh 启动脚本要用bash启动脚本,否则echo -n 不工作
for i in $var;
do
   echo -n  $i"_";
done

# 可以使用awk进行处理，使用split将数组放在var_arr中,
# 注意下标是1,而不是0
echo $var | awk '{printf("%d-%s\n", split($0, var_arr, " "), var_arr[1]);}'

# awk 使用 NF 来表示域的总数，类似于上面数组的长度
echo $var | awk '{printf("%d | %s, %s, %s, %s, %s | %s\n", NF, $1, $2, $3,$4, $5, $0)}'

echo $var | awk '{split($0, var_arr, " "); for(i in var_arr) printf("--%s--\n", var_arr[i]);}'

# mac没有System.map所以这个hash先不写了

# awk '{if(FILENAME ~ "System.map") map[$3]=$1; else {printf("%s\n", map[$1])}}' System.map symbol

# 按照位置取子串

echo "取出var中的0-3位置的字母" && echo ${var:0:3}
echo ${var:(-2)}

echo `expr substr "$var" 5 3`
echo $var | awk '{printf("%s\n", substr($0, 9, 6))}'

echo "awk 可以把空格分开为多个变量"
echo $var | awk '{printf("%s\n", $1);}'
echo $var | awk '{printf("%s\n", $5);}'

echo $var | cut -d" "  -f 4
echo "用bash内置求子串，了解就好，关键时候还要用python"
echo ${var%% *}
echo ${var% *}
echo ${var##* }
echo ${var#* }


echo "用sed进行子串分析，这个可以有"
echo $var | sed 's/ [a-z]*//g'
echo $var | sed 's/[a-z]* //g'

echo "使用分行以后按行打印"
echo $var | tr " " "\n" | sed -n 5p
echo $var | tr " " "\n" | sed -n 1p

# tr -d 是删除， -c 是反选的意思 complement 所以-cd就是不删除
echo $var | tr -d " "
echo $var | tr -cd "[a-z]"

echo "abcdefghijk" | head -c 4
echo "abcdefghijk" | tail -c 4

echo "查询子串或者字符在目标串中的位置"
expr index "$var" t
echo $var | awk '{printf("%d\n", match($0, "the"));}'

echo "最简单的打印包含某些字段的行"
grep "consists of" other_sample/newcomments
# -H 是打印文件名, -n 是打印行号
grep "consists[[:space:]]of" -n -H  other_sample/newcomments
grep "consists[[:space:]]of" -H -o other_sample/newcomments
awk '/consists of/{printf("%s:%d:%s\n", FILENAME, FNR, $0)}' other_sample/newcomments
sed -n -e '/consists of/=;/consists of/p' other_sample/newcomments

echo "子串替换成其他字符串,可以用作插入和删除子串"
echo ${var/ /_}
echo ${var// /_}

#awk提供了最小替换函数sub以及全局替换函数gsub类似于/和//
echo $var | awk '{sub(" ", "_", $0); printf("%s\n", $0);}'
echo $var | awk '{gsub(" ", "_", $0); printf("%s\n", $0);}'

#sed非常擅长子串替换
echo $var | sed -e "s/ /_/"
echo $var | sed -e "s/ /_/g"

# tr 命令也可以替换单个字符
echo $var | tr " " "_"
echo $var | tr "[a-z]" '[A-Z]'

# 插入子串
echo ${var/ /_ }
echo ${var// /_}
# 括号中默认是标签，\1,\2表示
echo $var | sed -e 's/\( \)/_\1/'
echo $var | sed -e 's/\( \)/_\1/g'

echo $var | sed -e 's/\([a-z]*\) \([a-z]*\) /\2 \1 /g'
# 这里出错了，如何用sed插入待补充
echo $var | sed '/get/a test'

# 删除字符串中的空格
echo ${var// /}
echo $var | awk '{gsub(" ", "", $0); printf("%s\n", $0);}'
echo $var | sed 's/ //g'
echo $var | tr -d " "

echo "下面开始排序了"
echo $var | tr " " "\n" | sort
echo $var | tr " " "\n" | sort -r

# ibase 是输入进制，obase是输出进制
echo "ibase=10;obase=16;10" | bc
nihao_utf8=$(echo "你好")
nihao_gb2312=$(echo $nihao_utf-8 | iconv -f utf8 -t gb2312)
echo $nihao_gb2312

url="ftp://anonymour:ftp@mirror.lzu.edu.cn/software/scim-1.4.7.tar.gz"

echo $url | grep "ftp://[a-z]*:[a-z]*@[a-z\./-]*"
# 获取服务器类型
echo ${url%%:*}
echo $url | cut -d ":" -f 1

# 获取域名
echo ${url##*@} | echo ${$1%%/*}
tmp=${url##*@}
echo ${tmp%%/*}

echo `basename $url`

echo $url | sed -e 's/.*[0-9].\(.*\)/\1/g'

# 匹配某个文件中特定范围的行
sed -n 7,9p other_sample/exercise.txt
awk '/7.2/,/^$/ {printf("%s\n", $0);}' other_sample/exercise.txt
cat /etc/passwd | cut -d":" -f1,4
cat /etc/passwd
echo "将指定的文件关联"
join -o 1.1,2.1 -t":" -1 4 -2 3 /etc/passwd /etc/group


# 文件操作
# echo>file, cat, touch, /dev/null, file, stat
# chown 用户名：组名 文件名   使用-R修改文件夹属性

#rwxr-x--x 751  7值得是所属用户， 5对所属组，1对应其他组
#chmod a+rwx file 表示所有用户都可读可写可执行
#chmod u 表示当前用户， 用减号-表示减去某些权限
ln other_sample/exercise.txt other_sample/exercise_hard_link.sh
ln -s other_sample/exercise.txt other_sample/exercise_soft_link.sh

#复习下解压缩
# 文件搜索
# 找到当前文件夹内所有.sh和.txt结尾的文件
find ./ -name "*.sh" -o -name "*.txt"
# 将找到的文件移动到c_files下
# find ./ \(-name "*.sh" -o -name "*.txt"\) -exec mv '{}' ./c_files/
#find ./ -name "*.sh" -o -name "*.txt" | xargs -i ./other_sample/toupper.sh "{}" ./c_files/
#toupper.sh是一个转大写为小写的文件

# 查看进程属性和状态
# ps -ef
# 选择某个特定用户启动的进程
# ps -U cnetwork
# 使用Ps, pstree, top动态查看进程信息
# linux排查网络问题需要检查各个层次：物理链接、链路层、网络层直到应用层可以用一下工具
# ethereal/tcpdump, hping, nmap, netstat, netpipe, netperf, nvstat, ntop

