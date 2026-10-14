<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Mews\Captcha\Captcha;

class CaptchaController extends Controller
{
    public function getCaptchaHTML()
    {
        return captcha_src();
    }
}
