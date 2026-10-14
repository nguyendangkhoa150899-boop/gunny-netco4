<?php

namespace App\Http\Requests\Client\TwoFactor;

use Illuminate\Foundation\Http\FormRequest;

class VerifyTwoFactorRequest extends FormRequest
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
            'code' => 'required|integer',
            'captcha' => 'required|captcha'
        ];
    }

    public function messages()
    {
        return [
            'captcha.captcha' => 'Mã captcha không chính xác, vui lòng nhập kết quả. Ví dụ: 10+1=11 thì bạn nhập 11 là được nhé !',
            'captcha.required' => 'Bạn chưa nhập captcha',
            'code.required' => 'Bạn chưa nhập mã xác thực',
            'code.integer' => 'Mã xác thực phải là số',
        ];
    }
}
