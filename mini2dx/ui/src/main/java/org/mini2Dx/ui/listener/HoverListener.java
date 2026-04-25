/*******************************************************************************
 * Copyright 2019 See AUTHORS file
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
package org.mini2Dx.ui.listener;

import org.mini2Dx.ui.element.Hoverable;

/**
 * Common interface for listening to mouse hover events
 */
public interface HoverListener {
	/**
	 * Called when the mouse begins hovering a {@link Hoverable}
	 * @param source The {@link Hoverable} that the mouse began hovering
	 */
	public void onHoverBegin(Hoverable source);
	
	/**
	 * Called when the mouse finishes hovering a {@link Hoverable}
	 * @param source The {@link Hoverable} that the mouse finished hovering
	 */
	public void onHoverEnd(Hoverable source);
}
