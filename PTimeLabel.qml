/**
 * Copyright (c) 2015 Dinesh Manajpet
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/

import QtQuick 2.0

PLabel {
    property date timestamp

    property string prefix: ''

    function getMinutes(date){
        if(date.getMinutes() < 10)
            return '0' + date.getMinutes();
        return '' + date.getMinutes();
    }

    function getHour(date) {
        if(date.getHours() < 13)
        {
            if(date.getHours() !== 0) return date.getHours();
            else return '12'
        }
        return (date.getHours() - 12);
    }

    function getMeridiem(date) {
        if(date.getHours() < 13)
            return 'am'
        return 'pm'
    }

    function getDate(date){
        date = date.getDate();
        var suffix;

        if(date === 3 || date === 23)
            suffix = 'rd';
        else if(date === 2 || date === 22)
            suffix = 'nd';
        else if(date === 1 || date === 21 || date === 31)
            suffix = 'st';
        else
            suffix = 'th';

        return date + suffix;
    }

    function getDay(date) {
        switch(date.getDay()) {
        case 0: return 'Sunday'
        case 1: return 'Monday'
        case 2: return 'Tuesday'
        case 3: return 'Wednesday'
        case 4: return 'Thursday'
        case 5: return 'Friday'
        case 6: return 'Saturday'
        }
        return ''
    }

    function getMonth(date) {
        switch(date.getMonth()) {
        case 0: return 'January'
        case 1: return 'February'
        case 2: return 'March'
        case 3: return 'April'
        case 4: return 'May'
        case 5: return 'June'
        case 6: return 'July'
        case 7: return 'August'
        case 8: return 'September'
        case 9: return 'October'
        case 10: return 'November'
        case 11: return 'December'
        }
        return ''
    }

    function getFancyTimestamp(timestamp){
        var date = new Date()
        var sDate = new Date(timestamp)
        var diff = Math.floor(((date - sDate) / 1000))

        var future = false

        if(diff < 0){
            future = true
            diff = diff * -1
        }

        if(diff < 30)
            return 'Just now'

        var futureString = future? 'away' : 'ago'
        if(diff < 60)
            return diff.toString() + ' seconds ' + futureString


        if(diff < 3600)
            return (Math.floor(diff /60)).toString() + ' minutes ' + futureString

        if(diff < 10800){
            var plural = ''
            if((diff/ 3600) >= 2 )
                plural = 's'
            return 'About '+(Math.floor(diff/3600))+ ' hour' + plural + ' ' + futureString
        }

        var minutes = getMinutes(sDate)
        var hour = getHour(sDate)
        var meridiem = getMeridiem(sDate)
        var dateString = getDate(sDate)
        var dayString = getDay(sDate)
        var monthString = getMonth(sDate)

        //Less than 24 hours
        if(diff < 86400 && sDate.getDay() === date.getDay())
            return hour + ':' + minutes + meridiem

        //Less than 2 days
        if(diff < 172800)
            return hour + ':' + minutes + meridiem //+ ' ' + futureString

        //Less than a week
        if(diff < 604800)
            return hour + ':' + minutes + meridiem + ' on ' + dayString

        //More than a week but in the same month
        if(sDate.getMonth() === date.getMonth())
            return hour + ':' + minutes + meridiem + ' on ' + dayString + ' the ' + dateString

        //Same Year
        if(sDate.getFullYear() === date.getFullYear())
            return hour + ':' + minutes + meridiem + ' on ' + dayString + ', ' + monthString + ' ' + dateString

        return hour + ':' + minutes + meridiem + ' on ' + dayString + ' the ' + dateString + ' of ' + monthString + ', ' + sDate.getFullYear()
    }

    
    label: prefix + getFancyTimestamp(timestamp)
}
