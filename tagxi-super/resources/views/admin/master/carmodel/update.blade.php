@extends('admin.layouts.app')
@section('title', 'Main page')

@section('content')
{{-- {{session()->get('errors')}} --}}

    <!-- Start Page content -->
    <div class="content">
        <div class="container-fluid">

            <div class="row">
                <div class="col-sm-12">
                    <div class="box">

                        <div class="box-header with-border">
                            <a href="{{ url('carmodel') }}">
                                <button class="btn btn-danger btn-sm pull-right" type="submit">
                                    <i class="mdi mdi-keyboard-backspace mr-2"></i>
                                    @lang('view_pages.back')
                                </button>
                            </a>
                        </div>

                        <div class="col-sm-12">

                            <form method="post" class="form-horizontal" action="{{ url('carmodel/update',$item->id) }}">
                                @csrf

                         <div class="row">
                             <div class="col-6">
                                        <div class="form-group">
                                            <label for="">@lang('view_pages.transport_type') <span class="text-danger">*</span></label>
                                            <select name="transport_type" id="transport_type" class="form-control" required>
                                                <option value="" selected disabled>@lang('view_pages.select')</option>
                                                <option value="taxi" {{ old('transport_type',$item->makeDetail->transport_type) == 'taxi' ? 'selected' : '' }}>@lang('view_pages.taxi')</option>
                                                <option value="delivery" {{ old('transport_type',$item->makeDetail->transport_type) == 'delivery' ? 'selected' : '' }}>@lang('view_pages.delivery')</option>
                                                <option value="both" {{ old('transport_type',$item->makeDetail->transport_type) == 'both' ? 'selected' : '' }}>@lang('view_pages.both')</option>
                                            </select>
                                            <span class="text-danger">{{ $errors->first('transport_type') }}</span>
                                        </div>
                                    </div>
                                 <div class="col-6">
                                            <div class="form-group">
                                                <label for="make_id">@lang('view_pages.vehicle_make')<span class="text-danger">*</span></label>
                                            <select name="make_id" id="make_id" class="form-control select2" data-placeholder="@lang('view_pages.select_make_id')"
                                                required>
                                                    <option value="" selected disabled>@lang('view_pages.select')</option>
                                                </select>
                                            </div>
                                         </div>
                                    <div class="col-12">
                                        <div class="form-group">
                                            <label for="name">@lang('view_pages.name') <span class="text-danger">*</span></label>
                                            <input class="form-control" type="text" id="name" name="name"
                                                value="{{ old('name',$item->name) }}" required=""
                                                placeholder="@lang('view_pages.enter') @lang('view_pages.name')">
                                            <span class="text-danger">{{ $errors->first('name') }}</span>
                                        </div>
                                    </div>

                                <div class="form-group">
                                    <div class="col-12">
                                        <button class="btn btn-primary btn-sm pull-right m-5" type="submit">
                                            @lang('view_pages.update')
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- container -->
</div>
    <!-- content -->

    <script src="{{ asset('assets/vendor_components/jquery/dist/jquery.js') }}"></script>
    <script>
        $(document).on('change', '#transport_type', function() {
            let value = $(this).val();
// console.log(value);
            $.ajax({
                url: "{{ route('getVehicleMake') }}",
                type: 'GET',
                data: {
                    'transport_type': value,
                },
                success: function(result) {            
                    $('#make_id').empty();
                    $("#make_id").append('<option value="" selected disabled>Select</option>');
                    result.forEach(element => {
                        $("#make_id").append('<option value=' + element.id + '>' + element
                            .name + '</option>')
                    });
                    $('#make_id').select();
                }
            });
        });
   
$(document).on('change','#transport_type',function(){
        getVehicleMake($(this).val());
    });
    </script>


@endsection
