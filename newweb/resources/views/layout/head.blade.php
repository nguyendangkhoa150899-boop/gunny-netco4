<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <title>Gogun.vn - Tìm lại ký ức Gà</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/css/iCielSoupOfJustice.css" />
    <link rel="stylesheet" href="/vendor/bootstrap-5.0.1-dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/vendor/fontawesome-free-5.15.3-web/css/all.min.css" />
    <link rel="stylesheet" href="/css/alertify.min.css" />
    <link rel="stylesheet" href="/css/themes/default.min.css" />
    <link rel="stylesheet" href="/css/app.css?v=20210729014200" />
    <link rel="icon" type="image/png" href="/favicon.png">
    @yield('custom_css')
    <script src="/vendor/bootstrap-5.0.1-dist/js/bootstrap.min.js"></script>
    <script src="/js/alertify.min.js"></script>
    <script src="/js/jquery-3.6.0.min.js"></script>
    <script src="/js/app.js"></script>
    <script>
        var showLoading = function () {
            $(".overlay-loading").css('display', 'flex').hide().fadeIn();
        }
        var hideLoading = function () {
            $(".overlay-loading").fadeOut();
        }
    </script>
    @yield('custom_js')
</head>
