<?php

namespace App\Http\Controllers\AjaxPublic;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\AjaxPublic\CheckValidUsernameRequest;
use App\Http\Requests\AjaxPublic\CheckValidEmailRequest;
use App\Member;

class RegisterHelperController extends Controller
{
    public function checkValidUsername(CheckValidUsernameRequest $request)
    {
        $isFound = Member::select("Email")
                    ->where('Email',$request->only('Email'))
                    ->first();
        if($isFound)
            return response()->json(['msg'=>'Tên tài khoản đã được sử dụng'], 400);
        return response()->json(['msg'=>'Tên tài khoản hợp lệ'], 200);
    }

    public function checkValidEmail(CheckValidEmailRequest $request)
    {

        $isFound = Member::select("FullName")
            ->where('Fullname',$request->only('Fullname'))
            ->first();
        if($isFound)
            return response()->json(['msg'=>'Địa chỉ email đã được sử dụng'], 400);
        return response()->json(['msg'=>'Địa chỉ email hợp lệ'], 200);
    }
}
