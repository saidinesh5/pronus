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

pragma Singleton
import QtQuick 2.0

ListModel {
    id: notificationsModel

    /**
     * Posts a notification to the global notifications
     * level: one of['error', 'info', 'success', 'warning']
     * msg: message text
     * category: (optional) category to assign this message to, so you can group purge them
     * returns the id of this notification
     */
    function postNotification(level, msg, category)
    {
        notificationsModel.append({ level: level, category: category, message: msg })
        return notificationsModel.count - 1
    }

    /**
     * Remove one notification that matches the given message (and category)
     */
    function removeNotification(message, category)
    { 
        var i = notificationsModel.indexOf(category,message)
        if(i !== -1)
            notificationsModel.remove(i)
        return i
    }

    /**
     * Purge notifications belonging to a particular category.
     * If no category is mentioned, all notifications will be cleared.
     */
    function purgeNotifications(category)
    {
        if(category === undefined || category === -1)
        {
            var result = notificationsModel.count
            notificationsModel.clear()
            return result
        }

        var toDelete = []
        for( var i = 0; i< notificationsModel.count; i++ )
            if(notificationsModel.get(i).category === category)
                toDelete.push(i)

        for( var j = 0; j < toDelete.length; j++ )
            notificationsModel.remove( toDelete[j] - j )

        return toDelete.length
    }

    /**
     * Given a message and a category, return it's index if found, else return -1
     */
    function indexOfNotification(message, category)
    {
        for(var i = 0; i < notificationsModel.count; i++)
        {
            var backend = notificationsModel.get(i)
            if( backend.message === message )
                if(category && backend.category && backend.category === category)
                    return i
        }
        return -1;
    }
}
