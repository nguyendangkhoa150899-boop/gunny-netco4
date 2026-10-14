<?php


namespace App\Models;


class Article extends \Backpack\NewsCRUD\app\Models\Article
{
    protected $fillable = ['slug', 'title', 'description', 'content', 'image', 'status', 'category_id', 'featured', 'date'];

    protected $attributes = [
        'category_id' => 0
    ];
}
