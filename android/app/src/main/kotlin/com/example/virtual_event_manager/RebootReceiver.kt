package com.example.virtual_event_manager

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import android.widget.Toast
import io.flutter.util.PathUtils
import java.text.SimpleDateFormat

class RebootReceiver : BroadcastReceiver(){

    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent!!.action == "android.intent.action.BOOT_COMPLETED"
                || intent.action == "android.intent.action.QUICKBOOT_POWERON"
                || intent.action == "android.intent.action.REBOOT"){
            val db = DatabaseHelper(context!!)
            val rem = db.getEvents()
            if(!rem.isEmpty()){
                for(event in rem){
                    val intent = Intent("com.example.virtual_event_manager.RING")
                    intent.putExtra("Id",event[0])
                    intent.putExtra("Text",event[1])
                    intent.putExtra("Date",event[2])
                    intent.putExtra("Time",event[3])
                    intent.putExtra("Silent",event[4])
                    intent.putExtra("Repeat",event[5])
                    val id = event[0]
                    val pendingintent = PendingIntent.getBroadcast(context,id.toInt(),intent,0)
                    val manager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                    val time = getTime(event[2],event[3])
                    manager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,time.toLong(),pendingintent)
                }
            }
            db.close()
        }
    }

    @SuppressLint("SimpleDateFormat")
    private fun getTime(date: String, time: String): String{
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
        val datetime = sdf.parse(date +  "T" + time)
        return datetime.time.toString()
    }
}


class DatabaseHelper(context: Context) {
    private val dbPath = context.getDatabasePath(DATABASE_NAME).path
    private var sqliteDatabase: SQLiteDatabase

    init {
        sqliteDatabase = SQLiteDatabase.openDatabase(dbPath, null,
                SQLiteDatabase.CREATE_IF_NECESSARY)
    }

    fun getEvents(): List<List<String>> {
        var reminders :MutableList<List<String>> = mutableListOf()
        if(sqliteDatabase.isOpen){
            val data = sqliteDatabase.rawQuery("SELECT * FROM $TABLE_NAME",null)
            if(data.count != 0){
                while(data.moveToNext()) {
                    val singleReminder = listOf(data.getString(0), data.getString(1), data.getString(2), data.getString(3), data.getString(4), data.getString(5))
                    reminders.add(singleReminder)
                }
            }
            data.close()
        }
        return reminders
    }

    fun update(date: String,time: String,id: String){
        var args: ContentValues = ContentValues()
        args.put("Date",date)
        args.put("Time",time)
        if(sqliteDatabase.isOpen){
            sqliteDatabase.update(TABLE_NAME,args,"Id = ?", arrayOf(id))
        }
    }

    fun close() {
        sqliteDatabase.close()
    }

    companion object {
        @Synchronized
        fun getInstance(context: Context): DatabaseHelper {
            if (instance == null) instance = DatabaseHelper(context)
            return instance as DatabaseHelper
        }

        var instance: DatabaseHelper? = null
        private const val TABLE_NAME = "Events"
        private const val DATABASE_NAME = "EventManager.db"
    }
}