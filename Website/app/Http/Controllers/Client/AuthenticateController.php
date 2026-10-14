<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use App\Http\Requests\Client\TransferAccountRequest;
use App\Member;
//use Illuminate\Http\Request;
use App\Http\Requests\Client\Authenticate\MemberLoginRequest;
use App\Http\Requests\Client\Authenticate\MemberRegisterRequest;
use App\MemberGoGun;
use App\Notifications\TwoFactorCodeNotification;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthenticateController extends Controller
{
    private function active2FAMode()
    {
        $member = Auth::guard('member')->user();
        if($member->TwoFactorStatus && $member->VerifiedEmail){
            $member->generateTwoFactorCode();
//            $member->notify(new TwoFactorCodeNotification()); //Deprecated
        }
    }

    public function login(MemberLoginRequest $request)
    {
        $member = Member::where('Email', $request->input('username'))->first();

        if (Auth::guard('member')->attempt(['Email' => $request->input('username'), 'password' => $request->input('password')])) {
            $this->active2FAMode();
            if($member->IsBan == 1)
                return response()->json(['msg' => "Tài khoản này đã bị khoá!"],401);
            $ref = session('ref');
            if (!empty($ref)) {
                session(['ref' => '']);
                $member->Email = strtolower($member->Email);
                $member->ActiveIP = $request->ip();
                $member->save();
                return response()->json(['msg' => "Đăng nhập thành công", 'ref' => $ref],200);
            }
            return response()->json(['msg' => "Đăng nhập thành công"],200);
        }
        return response()->json(['msg' => "Tài khoản hoặc mật khẩu không đúng!"],401);
    }

    public function showRegister()
    {
        return view('client.register');
    }

    public function register(MemberRegisterRequest $request)
    {
        $username = $request->input('Email');
        $phone = $request->input('Phone');
        $usernameLower = strtolower($username);
        $newMember = Member::create([
            'Email' => $usernameLower,
            'Password' => Hash::make($request->input('Password')),
            'Phone' => $phone,
            'Fullname' => $request->input('Fullname'),
            'Money' => 0,
            'TimeCreate' => time(),
            'IPCreate' => $request->ip(), //Without antiddos.vn
//            'IPCreate' => $request->header('x-real-ip'),
            'MoneyLock' => 0,
        ]);
        if (!$newMember){
            return response()->json(['msg'=> 'Đăng ký thất bại, lỗi server vui lòng thử lại'], 422);
        }
        Auth::guard('member')->loginUsingId($newMember->UserID);
        return response()->json(['msg'=> 'Đăng ký thành công'], 201);
    }

    public function logout()
    {
        Auth::guard('member')->logout();
        return redirect(route('home'));
    }

    public function transferPasswordFromS1(TransferAccountRequest $request)
    {
        $username = $request->input('Email');
        $password = $request->input('Password');

        $existedMember = MemberGoGun::where('Email', $username)
            ->where('Password', md5($password))
            ->first();
        if($existedMember){
            Member::where('Email', $username)->update(['Password' => Hash::make($password)]);
            return response()->json(['msg'=> 'Chuyển đổi tài khoản thành công, vui lòng đăng nhập ở góc trái màn hình.']);
        }
        return response()->json(['msg'=> 'Tài khoản hoặc mật khẩu cũ từ web cũ không đúng (Hoặc đã chuyển đổi rồi).'], 400);
    }

    public function showFormWithPuffin()
    {
        return view('client.index');
    }

    public function loginWithPuffin(MemberLoginRequest $request)
    {
        if (Auth::guard('member')->attempt(['Email' => $request->input('username'), 'password' => $request->input('password')])) {
            $this->active2FAMode();
            return redirect(route('home'));
        }
        return back()->withErrors(['msg'=>'Tài khoản hoặc mật khẩu không đúng']);
    }
}
