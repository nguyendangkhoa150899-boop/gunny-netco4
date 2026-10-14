<?php

namespace App\Http\Requests\Client\Authenticate;

use Illuminate\Foundation\Http\FormRequest;

class MemberRegisterRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'Email' => 'required|string|alpha_dash|min:5|max:255|unique:sqlsrv_mem.Mem_Account',
            'Fullname' => 'required|email|max:50|unique:sqlsrv_mem.Mem_Account',
            'Password' => 'required|string|min:6|regex:/[a-z]/|regex:/[A-Z]/|regex:/[0-9]/|regex:/[@$!%*#?&]/',
            'Phone' => 'required|unique:sqlsrv_mem.Mem_Account|digits:10',
            'captcha' => 'required|captcha',
        ];
    }

    public function messages()
    {
        return [
            'captcha.captcha' => 'Mã captcha không chính xác, vui lòng nhập kết quả. Ví dụ: 10+1=11 thì bạn nhập 11 là được nhé !',
            'captcha.required' => 'Bạn chưa nhập captcha',
            'Fullname.required' => 'Bạn chưa nhập địa chỉ email',
            'Fullname.email' => 'Địa chỉ email không hợp lệ',
            'Password.required' => 'Bạn chưa nhập mật khẩu',
            'Password.min' => 'Mật khẩu tối thiểu phải 6 ký tự trở lên',
            'Password.regex' => 'Mật khẩu phải chứa số, kí tự, chữ hoa và chữ thường',
            'Phone.required' => 'Bạn chưa nhập số điện thoại',
            'Phone.digits' => 'Số điện thoại không hợp lệ',
            'Phone.unique' => 'Số điện thoại đã có người đăng ký',
            'Email.required' => 'Bạn chưa nhập tên tài khoản',
            'Email.alpha_dash' => 'Tên tài khoản không hợp lệ',
            'Email.min' => 'Tài khoản tối thiểu phải 5 ký tự trở lên',
        ];
    }
}
