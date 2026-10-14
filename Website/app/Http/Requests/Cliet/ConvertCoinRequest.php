<?php

namespace App\Http\Requests\Cliet;

use Illuminate\Foundation\Http\FormRequest;

class ConvertCoinRequest extends FormRequest
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
            'server_id' => 'required|numeric',
            'coin' => 'required|numeric|min:0|max:100000000000',
            'captcha' => 'required|captcha'
        ];
    }

    /**
     * Get the validation messages that apply to the request.
     *
     * @return array
     */
    public function messages()
    {
        return [
            'server_id.required' => 'Vui lòng nhập Máy chủ muốn chuyển xu.',
            'server_id.numeric' => 'Vui lòng nhập Máy chủ muốn chuyển xu.',
            'coin.required' => 'Vui lòng nhập Số coin muốn chuyển.',
            'coin.min' => 'Số coin phải lớn hơn 5.000',
            'coin.max' => 'Số coin lớn nhất được chuyển là 100.000.000.000',
            'coin.numeric' => 'Số coin là một số nguyên dương từ 1.000 đến 100.000.000.000',
            'captcha.required' => 'Vui lòng nhập Captcha.',
            'captcha.captcha' => 'Sai captcha'
        ];
    }
}
