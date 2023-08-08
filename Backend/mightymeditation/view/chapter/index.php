<?php
    require_once('../configuration/Connection.php');
    require_once('../model/Chapter.php');

    $chapter = new Chapter();
    $audio_id = isset($_GET) && isset($_GET['id']) ? $_GET['id'] : null;
    $records = $chapter->mightyGetRecord($audio_id);
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $chapter->setFields($_POST);
        $chapter->mightyDelete();
    }
?>   
<div class="card-body">
    <div class="table-responsive">
        <table id="" class="table data-table table-bordered">
            <thead>
                <tr>
                    <th data-orderable="false">Image</th>
                    <th>Name</th>
                    <th>URL</th>
                    <th data-orderable="false">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php 
                    if(count($records) > 0){
                        foreach( $records as $data ){
                        ?>
                            <tr>
                                <td>
                                    <div class="mm-avatar col-md-2">
                                        <img class="avatar-40 rounded" src="../upload/chapter/<?= $data['image'] ?>" alt="#img" data-original-title="" title="">
                                    </div>    
                                </td> 
                                <td><?= $data['name'] ?></td>
                                <td><?= $data['type'] == 'file' ? $data['file'] : $data['url'] ?></td>
                                <td>
                                    <div class="d-flex align-items-center list-action">                                                
                                        <a class="badge bg-primary-light mr-2" data-toggle="tooltip" data-placement="top" title="" data-original-title="Edit" href="?page=chapter_create&id=<?= $data['id'] ?>" ><i class="las la-edit"></i></a>
                                        <a class="badge bg-danger-light mr-2" data-toggle="modal" data-target="#exampleModal<?= $data['id'] ?>" data-placement="top" title="" data-original-title="Delete" href="#"><i class="las la-trash-alt"></i></a>
                                    </div>
                                </td>
                                <!-- Modal -->
        <div class="modal fade" id="exampleModal<?= $data['id'] ?>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Delete Chapter</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="exapleFormModal<?= $data['id'] ?>" method="post" action="">
                        <div class="modal-body">
                            <input type="hidden" name="id" value="<?= $data['id'] ?>" />
                            <h4>Are you sure want to delete ?</h4> 
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Delete</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
                                </td>
                            </tr>
                    <?php 
                        }
                    }
                ?>
            </tbody>
        </table>
    </div>
</div>
