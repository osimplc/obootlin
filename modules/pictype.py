

def pic_type(pt):
    
    if pt==0x36:
        PicType="16F 886/887";
        max_flash=0x2000;
        bsize=100;   
    elif pt==0x41:
        PicType="18F 252o/452o";
        max_flash=0x8000;
        bsize=100;
    else:
        PicType="Microcontroller not supported or not detected";
        max_flash=None;
        bsize=None;

    family=None

    if (pt==0x36):
        family="16F8XX"
   
    elif (pt==0x41):
        family="18F452X"
           
    return PicType, max_flash, family, bsize
