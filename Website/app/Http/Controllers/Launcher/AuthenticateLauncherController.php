<?php

namespace App\Http\Controllers\Launcher;

use App\Http\Controllers\Controller;
use App\Http\Requests\Client\Authenticate\MemberRegisterRequest;
use App\Http\Requests\Client\Launcher\ChangePasswordRequest;
use App\Http\Requests\Launcher\LoginLauncherRequest;
use App\Member;
use App\ServerList;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use SimpleXMLElement;

class AuthenticateLauncherController extends Controller
{
    public function login(LoginLauncherRequest $request)
    {
        $email = $request->input(('username'));
        $password = $request->input('password');

        if (Auth::guard('member')->attempt(['Email' => $email, 'password' => $password])) {
            $member = Auth::guard('member')->user();
            if($member->IsBan == 1)
                return response()->json(['success'=> false, 'message' => 'Tài khoản của bạn đã bị khoá']);

            $serverList = ServerList::select('ServerID', 'ServerName')->get();
            return response()->json([
                'success' => true,
                'message' => 'Đăng nhập thành công',
                'data' =>  [
                    'username' => $member->Email,
                    'email' => $member->Fullname,
                    'coin' => $member->Money,
                ],
                'servers' => $serverList,
            ]);
        }
        return response()->json(['success'=>false, 'message' => 'Đăng nhập thất bại']);
    }

    public function login2(LoginLauncherRequest $request)
    {
		

        $email = $request->input('username');
        $password = $request->input('password');

        if (Auth::guard('member')->attempt(['Email' => $email, 'password' => $password])) {
            $member = Auth::guard('member')->user();
            if($member->IsBan == 1)
                return response('Tài khoản của bạn đã bị khoá');

            $column = [
                DB::raw('ServerID as ID'),
                DB::raw('ServerName as Name'),
            ];
            $serverList = ServerList::select($column)->get();
            $serverList = $serverList->keyBy(function ($item) {
                return $this->convertViToEn($item['Name']);
            });

            $returnXml = array (
                'Play' => (json_decode(json_encode($serverList), true)),
                'List' => (json_decode(json_encode($serverList), true)),
                'Config' => [
                    'SuportUrl' => [
                        'SuportUrl' => ''
                    ],
                    'SiteName' => [
                        'SiteName' => 'GunGa'
                    ],
                    'Version' => [
                        'Version' => '1.0.0'
                    ],
					'convertRate' => [
                        'convertRate' => \App\Setting::get('he-so-doi-coin')
                    ],
                ],
            );
            $xmlElement = new SimpleXMLElement('<Result/>');
            $xmlElement->addAttribute('status', 'true');
            $xmlElement->addAttribute('message', 'Đăng nhập thành công');
            $content = $this->arrayToXml($returnXml, $xmlElement)->asXML();
            return response($content);
        }
        return response('Đăng nhập thất bại');
    }

    private function arrayToXml(array $arr, SimpleXMLElement $xml)
    {
        foreach ($arr as $k => $v) {
            if (is_array($v)) {
                $this->arrayToXml($v, $xml->addChild($k));
            } else {
                $xml->addChild($k, $v);
                $xml->addAttribute($k, $v);
            }
        }
        return $xml;
    }

    private function convertViToEn($str)
    {
        $str = preg_replace("/(à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ)/", "a", $str);
        $str = preg_replace("/(è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ)/", "e", $str);
        $str = preg_replace("/(ì|í|ị|ỉ|ĩ)/", "i", $str);
        $str = preg_replace("/(ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ)/", "o", $str);
        $str = preg_replace("/(ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ)/", "u", $str);
        $str = preg_replace("/(ỳ|ý|ỵ|ỷ|ỹ)/", "y", $str);
        $str = preg_replace("/(đ)/", "d", $str);
        $str = preg_replace("/(À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ)/", "A", $str);
        $str = preg_replace("/(È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ)/", "E", $str);
        $str = preg_replace("/(Ì|Í|Ị|Ỉ|Ĩ)/", "I", $str);
        $str = preg_replace("/(Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ)/", "O", $str);
        $str = preg_replace("/(Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ)/", "U", $str);
        $str = preg_replace("/(Ỳ|Ý|Ỵ|Ỷ|Ỹ)/", "Y", $str);
        $str = preg_replace("/(Đ)/", "D", $str);
        $str = preg_replace("/\s/", "", $str);

        return $str;
    }

    public function register(Request $request)
    {
        $token = $request->input('token');
        if (empty($token)) {
            return response('0|Dữ liệu không hợp lệ');
        }
        $token = explode("|", base64_decode($token));
        $input['Email'] = $token[0];
        $input['Password'] = $token[1];
        $input['Phone'] = $token[2];
        $input['ip'] = $token[4];
        //$validator = new Validator();
        $validator = Validator::make($input, [
            'Email' => 'required|string|alpha_dash|max:255|unique:sqlsrv_mem.Mem_Account',
            'Password' => 'required|string|min:6',
            'Phone' => 'required|unique:sqlsrv_mem.Mem_Account|digits:10',
            //'ip' => 'required|min:1|max:20|regex:/^[a-z0-9\_\.@]{1,20}$/i',
        ]);
        if ($validator->fails()) {
            return response('0|Dữ liệu không hợp lệ');
        }
        $usernameLower = strtolower($input['Email']);
        $newMember = Member::create([
            'Email' => $usernameLower,
            'Password' => Hash::make($input['Password']),
            'Phone' => $input['Phone'],
            'Fullname' => $input['Email'],
            'Money' => 0,
            'TimeCreate' => time(),
//            'IPCreate' => $request->ip(), //Without antiddos.vn
            'IPCreate' => $input['ip'],
            'MoneyLock' => 0,
        ]);
        if (!$newMember){
            return response('0|Đăng ký thất bại, lỗi server vui lòng thử lại');
        }
        return response('1|Đăng ký thành công');
    }

    public function changePassword(Request $request)
    {
        $token = $request->input('token');
        if (empty($token)) {
            return response('0|Dữ liệu không hợp lệ');
        }
        $token = explode("|", base64_decode($token));
        $input['Email'] = $token[0];
        $input['Password'] = $token[1];
        $input['OldPassword'] = $token[2];
        $input['NewPassword'] = $token[3];
        if (Auth::guard('member')->attempt(['Email' => $input['Email'], 'password' => $input['Password']])) {
            $member = Auth::guard('member')->user();
            if($member->IsBan == 1)
                return response('0|Tài khoản của bạn đã bị khoá');

            if (Hash::check($input['OldPassword'], $member->Password)) {
                $newHashedPassword = Hash::make($input['NewPassword']);
                Member::where('UserID', $member->UserID)
                    ->update(['Password' => $newHashedPassword]);
                return response('1|Thay đổi mật khẩu thành công.');
            }
            return response('0|Mật khẩu cũ không đúng!');
        }
        return response('0|Đăng nhập không hợp lệ!');
    }
}
