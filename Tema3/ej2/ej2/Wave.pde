public abstract class Wave {
    protected float _amplitude;
    protected float wLength;
    protected float velo;
    protected float t;
    

    public Wave(float amp, float L, float vel) {
        this._amplitude = amp;
        this.wLength = L;
        this.velo = vel;
        t = 0;

    }

    public abstract PVector calculateVariation(float x, float y, float z);

    public void setTime(float time) {
        t = time;
    }
}

public class DirectionalWave extends Wave {
    private PVector direction;

    public DirectionalWave(float _amplitude, float wLength, float velo, PVector direction) {
        super(_amplitude, wLength, velo);
        this.direction = direction.copy().normalize();
    }

    public PVector calculateVariation(float x, float y, float z) {
        float angle = 2.0 * PI / wLength * (direction.x*x + direction.z*z) + t*velo;
        float variation = _amplitude * sin(angle);
        return new PVector(0,variation,0);
    }
}

public class RadialWave extends Wave {
    private PVector center;

    public RadialWave(float _amplitude, float wLength, float velo, PVector center) {
        super(_amplitude, wLength, velo);
        this.center = center;
    }

    public PVector calculateVariation(float x, float y, float z) {
        float distanceSquared = pow(x - center.x, 2) + pow(z - center.z, 2);
        float distance = sqrt(distanceSquared);
        float angle = (2 * PI / wLength) * distance - velo * t;
        float variation = _amplitude * cos(angle);
        return new PVector(0, variation, 0);
    }
}

public class GerstnerWave extends Wave {
    private PVector direction;
    private float Q;
    private float Land;

    public GerstnerWave(float _amplitude, float wLength, float velo, PVector direction) {
        super(_amplitude, wLength, velo);
        this.direction = direction.copy().normalize();
        Land = 2.0 * PI / wLength;
        Q = PI*_amplitude*Land;  
    }

    public PVector calculateVariation(float x, float y, float z) {

        float angle = Land * ((direction.x*x + direction.z*z)+ velo*t);
        float dx = Q * _amplitude * direction.x * cos(angle);
        float dy = -_amplitude * sin(angle);
        float dz = Q * _amplitude * direction.z * cos(angle);
        return new PVector(dx, dy, dz);
    }
}
