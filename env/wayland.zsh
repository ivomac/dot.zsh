
# WAYLAND ENV

export TERMINAL="foot"
export MENU="menu"

export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export ELM_ENGINE=wayland
export ECORE_EVAS_ENGINE=wayland
export SDL_VIDEODRIVER=wayland

export WLR_RENDERER=gles2

export WLR_NO_HARDWARE_CURSORS=1
export WLR_DRM_NO_MODIFIERS=1
export WLR_DRM_NO_ATOMIC=1

export QUTE_QT_WRAPPER="PyQt6"

export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_SCALE_FACTOR_ROUNDING_POLICY=Round

export OMP_SCHEDULE=STATIC
export OMP_PROC_BIND=CLOSE
export GOMP_CPU_AFFINITY="N-M"
