<?php

namespace App\Http\Requests\Client\ForgotPassword;

use Illuminate\Foundation\Http\FormRequest;

class SendForgotPasswordEmailRequest extends FormRequest
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
            'username' => 'required',
            'captcha' => 'required|captcha'
        ];
    }

    public function messages()
    {
        return [
            'captcha.captcha' => 'Mã captcha không chính xác, vui lòng nhập kết quả. Ví dụ: 10+1=11 thì bạn nhập 11 là được nhé !',
            'captcha.required' => 'Bạn chưa nhập captcha',
            'username.required' => 'Bạn chưa nhập tên tài khoản',
            'username.alpha_dash' => 'Tên tài khoản không hợp lệ',
        ];
    }
}
