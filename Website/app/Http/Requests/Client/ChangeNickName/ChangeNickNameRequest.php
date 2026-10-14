<?php

namespace App\Http\Requests\Client\ChangeNickName;

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
            'new_name' => 'required|string|min:4|max:255',
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
            'server_id.required' => 'Vui lòng nhập Máy chủ muốn đổi tên.',
            'server_id.numeric' => 'Vui lòng nhập Máy chủ muốn đổi tên.',
            'new_name.required' => 'Vui lòng nhập tên muốn chuyển đổi.',
            'new_name.string' => 'Tên nhân vật phải là ký tự.',
            'new_name.min' => 'Ký tự tên nhân vật phải lớn hơn 4.',
            'new_name.max' => 'Ký tự tên nhân vật phải nhỏ hơn 255.',
            'captcha.captcha' => 'Mã captcha không chính xác, vui lòng nhập kết quả. Ví dụ: 10+1=11 thì bạn nhập 11 là được nhé !',
            'captcha.required' => 'Bạn chưa nhập captcha',
        ];
    }
}
