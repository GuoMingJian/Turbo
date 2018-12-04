PLIST_UTILITIS_DIR=$(dirname "${BASH_SOURCE[0]}")
source "${PLIST_UTILITIS_DIR}/paths.sh"

SEARCH_VALUE=''
# 输入参数为 需要查找的Key的路径 输出使用 SEARCH_VALUE 返回
searchInfoPlistValueByKey() {
  path=$SRCROOT
  key=$1
  dir=${path}
  files=`find ${dir} -name "tac_services_configurations*.plist" -maxdepth 100`
  files=`echo ${files[@]} | tr ' ' '\n' | sort -r`
  for file in ${files[@]}
  do
    appid=`/usr/libexec/PlistBuddy -c "Print ${key}" ${file}`
    if [  ${appid} ]; then
      SEARCH_VALUE="$appid"
      return 0
    fi
  done
}
