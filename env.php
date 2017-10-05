<?php

$options = getopt('e:', ["path:"]);

if(empty($options['e'])){
    exit("empty env param\nenter -e ENV\n");
}

$path_prefix = isset($options['path']) ? $options['path'] : '/var/www/';

$env = $options['e'];

$env_file_default = '.env.default';
$env_file = ".env.$env";

function get_env_content($filename){

    if(!file_exists($filename)){
        exit("file $filename not found\n");
    }

    $result = [];
    $content = explode("\n",file_get_contents($filename));

    foreach ($content as $value){
        if(preg_match('/^([^#\s=]+)\s*=\s*?([^\#]*?)$/u', $value, $match)){
            $result[$match['1']] = trim($match['2']);
        }
    }
    return $result;
}
function merge_env($env_default, $env_custom){
    foreach($env_custom as $key=>$value){
        $env_default[ $key ] = $env_custom[ $key ];
    }

    $result = [];
    foreach($env_default as $key => $value) {
        $result[] = "$key=$value";
    }
    return $result;
}

$env_file_arr           = get_env_content($path_prefix . $env_file);
$env_file_default_arr   = get_env_content($path_prefix . $env_file_default);
$result                 = merge_env($env_file_default_arr, $env_file_arr);



$header = "
################################################
#
#           ЭТОТ ФАЙЛ СГЕНЕРИРОВАН!
#     ЛЮБЫЕ ИЗМЕНЕНИЯ НЕОБХОДИМО ДЕЛАТЬ В
#      ↓   ↓   ↓   ↓   ↓   ↓   ↓   ↓   ↓
#    -------------------------------------
#    | .env.default + .env.{CURRENT_ENV} |
#    -------------------------------------
#
#         Генерация запускается через
#         php env.php -e CURRENT_ENV
################################################
\n";
file_put_contents($path_prefix . '.env', $header . implode("\n", $result));
