
#include "irrlichttypes_extrabloated.h"
#include "IGUIElement.h"

class GUIRectangleOutline : public gui::IGUIElement
{
public:
    GUIRectangleOutline(gui::IGUIEnvironment* env, gui::IGUIElement* parent, s32 id,
                        const core::rect<s32> &rect, video::SColor color);

    virtual void draw() override;

private:
    video::SColor m_color;
};