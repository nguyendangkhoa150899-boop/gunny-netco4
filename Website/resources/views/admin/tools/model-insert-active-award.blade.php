<div class="btn-group" data-toggle="buttons">
    <!-- Button trigger modal -->
    <button type="button" class="btn btn-sm btn-success" data-toggle="modal" data-target="#addActiveAward">
        Thêm phần thưởng
    </button>
    <!-- Modal -->
    <div class="modal fade" id="addActiveAward" tabindex="-1" role="dialog" aria-labelledby="addActiveAward" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Thêm phần thưởng</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="width: 100%;">
                    {!! $form !!}
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                </div>
            </div>
        </div>
    </div>
</div>

