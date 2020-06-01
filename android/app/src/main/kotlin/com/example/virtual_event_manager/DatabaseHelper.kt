package com.example.virtual_event_manager

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase


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

    fun delete(id: String){
        if(sqliteDatabase.isOpen){
            sqliteDatabase.delete(TABLE_NAME,"Id = ?", arrayOf(id))
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