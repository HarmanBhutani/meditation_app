<?php
    require_once('../configuration/Connection.php');
    require_once('../model/Category.php');

    $category = new Category();
    $records = $category->mightyGetRecord();
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $category->setFields($_POST);
        $category->mightyDelete();
    }
    
?>

<div class="container-fluid">
    <div class="row">
        <div class="col-lg-12">
           <div class="card card-block card-stretch card-height">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title">
                        <h4 class="card-title mb-0">Category List</h4>
                    </div>
                    <a href="?page=category_create" class="btn btn-primary">Add New</a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="" class="table data-table table-bordered">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th data-orderable="false">Image</th>                                   
                                    <th data-orderable="false" width="100px">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php 
                                    if(count($records) > 0){
                                        foreach( $records as $data ){
                                        ?>
                                            <tr>
                                                <td><?= $data['name'] ?></td>
                                                <td>
                                                    <div class="mm-avatar col-md-2">
                                                        <img class="avatar-40 rounded" src="../upload/category/<?= $data['image'] ?>" alt="#img" data-original-title="" title="">
                                                    </div>    
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center list-action">
                                                        <a class="badge bg-primary-light mr-2" data-toggle="tooltip" data-placement="top" title="" data-original-title="Edit" href="?page=category_create&id=<?= $data['id'] ?>" ><i class="las la-edit"></i></a>
                                                        <a class="badge bg-danger-light mr-2" data-toggle="modal" data-target="#exampleModal<?= $data['id'] ?>" data-placement="top" title="" data-original-title="Delete" href="#"><i class="las la-trash-alt"></i></a>
                                                    </div>
                                                </td>
                                                <!-- Modal -->
        <div class="modal fade" id="exampleModal<?= $data['id'] ?>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Delete Category</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form id="exapleFormModal<?= $data['id'] ?>" method="post" action="">
                        <div class="modal-body">
                            <input type="hidden" name="id" value="<?= $data['id'] ?>" />
                            <h4>All the related Audio will be deleted once you delete this Category!</h4>
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
            </div>
        </div>
        
    </div>
</div>