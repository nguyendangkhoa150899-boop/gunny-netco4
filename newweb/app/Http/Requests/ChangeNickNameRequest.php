<?php

namespace App\Http\Requests;

use App\Member;
use Illuminate\Foundation\Http\FormRequest;

class ChangeNickNameRequest extends FormRequest
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
            'new_name' => 'required|string|min:4|max:255',
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
            'new_name' => [
                'required' => 'Vui lòng nhập Số coin muốn chuyển.',
                'string' => 'Tên nhân vật phải là ký tự.',
                'min' => 'Ký tự tên nhân vật phải lớn hơn 4.',
                'max' => 'Ký tự tên nhân vật phải nhỏ hơn 255.',
            ],
            'captcha' => [
                'required' => 'Vui lòng nhập Captcha.',
                'captcha' => 'Sai captcha',
            ]
        ];
    }
}
