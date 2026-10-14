<?php

namespace App\Http\Requests\Client\Authenticate;

use Illuminate\Foundation\Http\FormRequest;

class MemberLoginRequest extends FormRequest
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
            'username'   => 'required|string',
            'password' => 'required|min:6'
        ];
    }

    public function messages()
    {
        return [
            'username.required' => 'Bạn chưa nhập tên tài khoản',
            'username.alpha_dash' => 'Tên tài khoản không hợp lệ',
            'password.required' => 'Bạn chưa nhập mật khẩu',
            'password.min' => 'Mật khẩu tối thiểu phải 6 ký tự trở lên',
        ];
    }
}
