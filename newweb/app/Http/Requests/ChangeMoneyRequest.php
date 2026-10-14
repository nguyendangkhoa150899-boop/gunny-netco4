<?php

namespace App\Http\Requests;

use App\Member;
use Illuminate\Foundation\Http\FormRequest;

class ChangeMoneyRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        // only allow updates if the user is logged in
        $m = new Member();
        return $m->isLoggedIn();
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
            'coin' => 'required|numeric|min:1000|max:1000000',
            'captcha' => 'required|captcha'
        ];
    }

    /**
     * Get the validation attributes that apply to the request.
     *
     * @return array
     */
    public function attributes()
    {
        return [
            //
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
            'server_id' => [
                'required' => 'Vui lòng nhập Máy chủ muốn chuyển xu.',
                'numeric' => 'Vui lòng nhập Máy chủ muốn chuyển xu.',
            ],
            'coin' => [
                'required' => 'Vui lòng nhập Số coin muốn chuyển.',
                'min' => 'Số coin phải lớn hơn 1000',
                'max' => 'Số coin lớn nhất được chuyển là 1000000',
                'numeric' => 'Số coin là một số nguyên dương từ 1000 đến 1000000'
            ],
            'captcha' => [
                'required' => 'Vui lòng nhập Captcha.',
                'captcha' => 'Sai captcha',
            ]
        ];
    }
}
