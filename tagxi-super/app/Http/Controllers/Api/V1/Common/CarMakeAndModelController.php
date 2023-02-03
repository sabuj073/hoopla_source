<?php

namespace App\Http\Controllers\Api\V1\Common;

use App\Models\Master\CarMake;
use App\Models\Master\CarModel;
use App\Http\Controllers\Api\V1\BaseController;
use Carbon\Carbon;
use Sk\Geohash\Geohash;
use Illuminate\Http\Request;

/**
 * @group Vehicle Management
 *
 * APIs for vehilce management apis. i.e types,car makes,models apis
 */
class CarMakeAndModelController extends BaseController
{
    protected $car_make;
    protected $car_model;

    public function __construct(CarMake $car_make, CarModel $car_model)
    {
        $this->car_make = $car_make;
        $this->car_model = $car_model;
    }

    /**
    * Get All Car makes
    *
    */
    public function getCarMakes()
    { 
        $transport_type = request()->transport_type;

        return $this->respondSuccess($this->car_make->active()->where('transport_type',$transport_type)->where('vehicle_make_for',request()->vehicle_type)->orderBy('name')->get());
    }

   

    /**
    * Get Car models by make id
    * @urlParam make_id  required integer, make_id provided by user
    */
    public function getCarModels($make_id)
    {
        return $this->respondSuccess($this->car_model->where('make_id', $make_id)->active()->orderBy('name')->get());
    }


    /**
     * Test Api
     * 
     * */
    public function testApi(Request $request){

       $current_day = Carbon::today()->addDay(2)->toArray();

       dd($current_day);

       $current_day = $current_day['dayOfWeek'];
       
       dd($current_day);
    }
}
