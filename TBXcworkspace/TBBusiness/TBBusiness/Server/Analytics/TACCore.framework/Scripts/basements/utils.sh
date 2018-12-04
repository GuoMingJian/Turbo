# 入参 path 要查找的路径, pattern 模式
SEARCH_FIELS=()
searchFiles() {
  path=$1
  pattern=$2
  files=`find ${path} -name "${pattern}" -maxdepth 100`
  if [ ${#files[@]} == 0 ]; then
    echo "xx"
  else
    files=`echo ${files[@]} | tr ' ' '\n' | sort -r`
    SEARCH_FIELS=${files[@]}
  fi
}
