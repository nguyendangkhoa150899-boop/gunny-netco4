<?php

namespace App\Http\Requests\Client;

use Illuminate\Foundation\Http\FormRequest;

class TransferAccountRequest extends FormRequest
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
            'Email' => 'required|string|max:255|',
            'Password' => 'required|string|min:6',
            'captcha' => 'required|captcha',
        ];
    }

    public function messages()
    {
        return [
            'Email.required' => 'Bạn chưa nhập tên tài khoản',
            'Email.alpha_dash' => 'Tên tài khoản không hợp lệ',
            'Password.required' => 'Bạn chưa nhập mật khẩu',
            'Password.min' => 'Mật khẩu tối thiểu phải 6 ký tự trở lên',
            'captcha.captcha' => 'Mã captcha không chính xác, vui lòng nhập kết quả. Ví dụ: 10+1=11 thì bạn nhập 11 là được nhé !',
            'captcha.required' => 'Bạn chưa nhập captcha',
        ];
    }
}
