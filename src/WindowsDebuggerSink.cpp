/* © Copyright CERN, 2019.  All rights not expressly granted are reserved.
 * WindowsDebuggerSink.cpp
 *
 *  Created on: Mar 18, 2019
 * 		Author: Benjamin Farnham <benjamin.farnham@cern.ch>
 *
 *  This file is part of Quasar.
 *
 *  Quasar is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public Licence as published by
 *  the Free Software Foundation, either version 3 of the Licence.
 *
 *  Quasar is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public Licence for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with Quasar.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <WindowsDebuggerSink.h>
#include <iostream>
#include <windows.h>

bool WindowsDebuggerSink::initialize()
{
	std::cout << "WindowsDebuggerSink::initialize" << std::endl;
	return true;
}

void WindowsDebuggerSink::logMessage(const std::string& msg)
{
	::OutputDebugString(msg.c_str());
}
