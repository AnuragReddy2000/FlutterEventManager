package com.example.virtual_event_manager

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.app.job.JobInfo
import android.app.job.JobScheduler
import android.content.*
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
            val jobInfo = JobInfo.Builder(25041997, ComponentName(context!!,MyRebootService::class.java))
                    .setOverrideDeadline(0)
                    .build()
            val scheduler = context.getSystemService(Context.JOB_SCHEDULER_SERVICE) as JobScheduler
            scheduler.schedule(jobInfo)
        }
    }
}

