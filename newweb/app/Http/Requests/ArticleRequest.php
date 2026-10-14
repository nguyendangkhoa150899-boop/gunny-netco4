<?php


namespace App\Http\Requests;


class ArticleRequest extends \Backpack\NewsCRUD\app\Http\Requests\ArticleRequest
{
    public function rules()
    {
        return [
            'title' => 'required|min:2|max:255',
            'slug' => 'unique:articles,slug,'.\Request::get('id'),
            'description' => 'nullable',
            'content' => 'required|min:2',
            'date' => 'required|date',
            'status' => 'required',
        ];
    }
}
