# nov/13/2019 15:29:35 by RouterOS 6.45.7#
# model = RouterBOARD wAP R-2nD
/system script
add dont-require-permissions=no name=sms-checker owner=admin policy=\
    read,test source=":local msgcount [/tool sms inbox print count-only]\r\
    \n\r\
    \nif (\$msgcount > 0) do={\r\
    \n  :local token \"id_bot:token\"\r\
    \n  :local chat \"chat_id\"\r\
    \n  :local text \"some text to your chat\"\r\
    \n\r\
    \n  /tool fetch mode=https url=\"https://api.telegram.org/bot\$token/sendM\
    essage\\\?chat_id=\$chat&text=\$text\" keep-result=no\r\
    \n}"
