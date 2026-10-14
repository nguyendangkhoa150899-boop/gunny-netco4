<?php

namespace App\Http\Requests\Client;

use Illuminate\Foundation\Http\FormRequest;

class ChangePhoneNumberRequest extends FormRequest
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
            'Phone' => 'required|unique:sqlsrv_mem.Mem_Account|digits:10',
            'captcha' => 'required|captcha',
        ];
    }

    public function messages()
    {
        return [
            'Phone.required' => 'Bạn chưa nhập số điện thoại',
            'Phone.digits' => 'Số điện thoại không hợp lệ',
            'Phone.unique' => 'Số điện thoại đã có người đăng ký',
            'captcha.captcha' => 'Mã captcha không chính xác, vui lòng nhập kết quả. Ví dụ: 10+1=11 thì bạn nhập 11 là được nhé !',
            'captcha.required' => 'Bạn chưa nhập captcha',
        ];

    }
}
