<?php

$sFolder = "E:\Gunny\gunga\NEW_GunGa\update";

define('PHPVIET_DIR', "E:\Gunny\gunga\NEW_GunGa\\");

//include/model/core/monitor.class.php
//module/core/monitor/list_monitor_action_call.js
//module/core/monitor/list_monitor.js
//module/core/monitor/list_monitor.js
//include/sms/sms.class.php

$sFiles = "
app/Http/Controllers/Client/AuthenticateController.php
app/Http/Middleware/Authenticate.php
app/Http/Middleware/MemberScope.php
resources/views/client/related/login-form.blade.php
resources/views/client/account/account.blade.php
app/Member.php
";

$aFile = explode(chr(10), $sFiles);
$iNotFile = 0;
foreach ($aFile as $fi) if(strlen(trim($fi)) == 0) $iNotFile++;
echo (COUNT($aFile) - $iNotFile)." need to update. Result\n";
$iCount = 0;
foreach ($aFile as $fi)
{
    if ($fi)
    {
        $fi = trim($fi);

        $fi = str_replace("\\", "/", $fi);
        $f = PHPVIET_DIR . $fi;
        $f = str_replace("\\", "/", $f);
        if (file_exists($f))
        {
            $fs = explode("/", $fi);
            unset($fs[count($fs) - 1]);
            $f1 = $sFolder . "/";
            foreach ($fs as $v)
            {
                $f1 .= $v . "/";
                if (!file_exists($f1))
                    mkdir($f1);
            }
            copy($f, $sFolder . "/" . $fi);
            echo "{$fi}";
        }
    }
}
