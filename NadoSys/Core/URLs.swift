//
//  URL.swift
//  testCustomControl
//
//  Created by PHUCLONG on 7/27/17.
//  Copyright © 2017 PHUCLONG. All rights reserved.
//

import Foundation

class URLs{
    init() {
        
    }
    public static let URL_HOME = "http:/viecdayroi.vn/"
    public static let URL = "http://api.system.nadobranding.com/api/"
    //public static let URL = "http://192.168.0.10:5000/api/"
    public static var URL_KPI: String = URL + "function/function"
    public static var URL_PRODUCT: String = URL + "product/all"
    public static var URL_OBJECTDATA: String = URL + "ObjectData/all"
    public static var URL_DISPLAYGUIDE: String = URL + "display/download"
    public static var URL_SHOP: String = URL + "employeeshop/shop"
    public static var URL_LOGIN: String = URL + "user/login"
    public static var URL_DISPLAY_SAVEDATA: String = URL + "display/save"
    public static var URL_DISPLAY_SAVEIMAGE: String = URL + "imagelist/save"
    public static var URL_COLLECT_SAVEDATA: String = URL + "promotion/save"
    public static var URL_COLLECT_SAVEIMAGE: String = URL + "promotion/saveimage"
    public static var URL_DISPLAYSTAND_SAVEDATA: String = URL + "display/saveStand"
    public static var URL_DISPLAYSTAND_SAVEIMAGE: String = URL + "display/SaveStandImages"
    public static var URL_SELLOUT_SAVEDATA: String = URL + "saleout/savelist"
    public static var URL_SELLOUT_SAVEIMAGE: String = URL + "imagelist/save"
    public static var URL_DOWNLOAD_DATA: String = URL + "downloaddata/getdata"
    public static var URL_DOWNLOAD_REGION: String = URL + "Location/getLocation"
    public static var URL_SHOP_SAVE: String = URL + "shop/updateProfile"
    
    public static var URL_STOCK_SAVEDATA: String = URL + "oos/save"
    public static var URL_STOCK_SAVEIMAGE: String = URL + "imagelist/save"
    
    public static var URL_ATTANDANCE_SAVE: String = URL + "attendance/uploadandroid"
    public static var URL_SHOP_PROFILE: String = URL + "shop/getShop"
    public static var URL_EMPLOYEE_SHOP_PROFILE: String = URL + "shop/getShop"
    public static var URL_POSM_GETDATA: String = URL + "posm/Get_POSMList_byEmployee"
    public static var URL_POSM_GETDATA_RESULT: String = URL + "posm/Get_POSMResult_byDate"
    public static var URL_POSM_GETDATA_STOCK: String = URL + "posm/Get_POSMStock_byDate"
    public static var URL_POSM_CREATE: String = URL + "posm/Create_POSMResult"
    public static var URL_POSM_CREATE_STOCK: String = URL + "posm/Create_POSMStock"
    public static var URL_REPORT_MARKETSHOP: String = URL + "Reportting/Get_Market_Shop_Summary"
    public static var URL_ALLSHOPS: String = URL + "shop/allshop"
    public static var URL_EMPLOYEE_AVG: String = URL + "Reportting/Get_Average_byShop"
    public static var URL_EMPLOYEE_Attandance: String = URL + "Attendance/byshop"
    public static var URL_DISPLAY_FIX: String = URL + "display/fixtures"
    public static var URL_SELLOUT_REPORT: String = URL + "Reportting/Get_Sell_ByTeam"
    public static var URL_SELLOUT_REPORT_DETAIL: String = URL + "Reportting/Get_Sell_ByTeam_byshop"
    
    public static var URL_RESGITER: String = URL + "candidate/register"
    public static var URL_CV: String = URL + "candidate/info"
    public static var URL_SUGGEST: String = URL + "jobs/suggestions"
    public static var URL_UPDATE_ACCOUNT: String = URL + "candidate/updateaccount"
    public static var URL_UPDATE_PASSWORD: String = URL + "candidate/changePassword"
    public static var URL_UPDATE_LOGIN: String = URL + "candidate/updateMobile"
    public static var URL_APPLY_JOB: String = URL + "jobs/actionjobs"
    public static var URL_APPLYED_JOB: String = URL + "candidate/jobapply"
    public static var URL_SAVED_JOB: String = URL + "candidate/jobsave"
    public static var URL_UPLOAD_AVATAR: String = URL + "candidate/uploadavatar"
    public static var URL_UPDATE_CV: String = URL + "candidate/updatecv"
    public static var URL_NOTIFY: String = URL + "Notifies"
    public static var URL_SETTING_INFORM: String = URL + "candidate/getsetting"
    public static var URL_SETUP_INFORM: String = URL + "candidate/settingInsert"
    public static var URL_PUBLIC_CV: String = URL + "candidate/updateAllowAccess"
    public static var URL_REGISTER_FB: String = URL + "candidate/registernopass"
    public static var URL_LOGIN_FB: String = URL + "candidate/authface"
    public static var URL_CHECK_SWAGGER: String = "http://api.aqua.nadobranding.com/api/account/login"
    
    public static var URL_UPLOAD: String = URL + "UploadData.ashx"
    public static var URL_DOWNLOAD: String = URL + "DownloadData.ashx"
    public static var URL_PRODUCT_GETLIST: String = URL + "product/GetProducts"
    public static var URL_PRODUCT_GETMODEL: String = URL + "product/GetModelByProduct"
    public static var URL_OBJECTDATA_GETLIST: String = URL + "objectdata/GetColorByProduct"
    public static var URL_SELLOUT: String = URL + "SELLIN.ashx"
   // public static var URL_SHOP: String = URL + "Shops.ashx"
    public static var URL_SELLOUT_SAVELIST: String = URL + "saleout/SaveList"
    public static var URL_SELLOUT_UPDATE: String = URL + "saleout/Update"
    public static var URL_SELLOUT_DELETE: String = URL + "saleout/Delete"
    
    public static var URL_STOCKOUT_SAVE: String = URL + "stock/SaveStock"
    public static var URL_STOCKOUT_SAVELIST: String = URL + "stock/SaveList"
    public static var URL_DISPLAY_GETLIST: String = URL + "display/GetList"
    public static var URL_IMAGEDISPLAY_GETLIST: String = URL + "imagedisplay/GetList"
    public static var URL_IMAGEDISPLAY_SAVE: String = URL + "imagedisplay/Save"
    public static var URL_IMAGEDISPLAY_SAVELIST: String = URL + "imagedisplay/SaveList"
    public static var URL_DISPLAY_SAVE: String = URL + "display/SaveStockDisplay"
    public static var URL_DISPLAY_SAVELIST: String = URL + "display/SaveList"
    public static var URL_COMPETITOR_SAVE: String = URL + "competitor/Save"
    public static var URL_COMPETITOR_SAVELIST: String = URL + "competitor/SaveList"
    public static var URL_ATTENDANCE_GETTIMESERVER: String = URL + "attendance/GetTimeServer"
    public static var URL_ATTENDANCE_GETLIST: String = URL + "attendance/GetList"
    public static var URL_ATTENDANCE_SAVE: String = URL + "attendance/Save"
    public static var URL_ATTENDANCE_SAVELIST: String = URL + "attendance/SaveList"
    public static var URL_UPLOAD_IMAGE: String = URL + "UploadImage.ashx"
   
    

}
