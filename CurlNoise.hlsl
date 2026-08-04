// --- Échantillon 1 : bruit à la position de base ---
float2 P0 = Position.xy * NoiseScale;
float2 i0 = floor(P0);
float2 f0 = frac(P0);
float a0 = frac(sin(dot(i0,               float2(127.1, 311.7))) * 43758.5453123);
float b0 = frac(sin(dot(i0 + float2(1,0), float2(127.1, 311.7))) * 43758.5453123);
float c0 = frac(sin(dot(i0 + float2(0,1), float2(127.1, 311.7))) * 43758.5453123);
float d0 = frac(sin(dot(i0 + float2(1,1), float2(127.1, 311.7))) * 43758.5453123);
float2 u0 = f0 * f0 * (3.0 - 2.0 * f0);
float n_center = lerp(a0, b0, u0.x) + (c0 - a0) * u0.y * (1.0 - u0.x) + (d0 - b0) * u0.x * u0.y;

// --- Échantillon 2 : bruit décalé en X ---
float2 P1 = P0 + float2(Epsilon, 0.0);
float2 i1 = floor(P1);
float2 f1 = frac(P1);
float a1 = frac(sin(dot(i1,               float2(127.1, 311.7))) * 43758.5453123);
float b1 = frac(sin(dot(i1 + float2(1,0), float2(127.1, 311.7))) * 43758.5453123);
float c1 = frac(sin(dot(i1 + float2(0,1), float2(127.1, 311.7))) * 43758.5453123);
float d1 = frac(sin(dot(i1 + float2(1,1), float2(127.1, 311.7))) * 43758.5453123);
float2 u1 = f1 * f1 * (3.0 - 2.0 * f1);
float n_dx = lerp(a1, b1, u1.x) + (c1 - a1) * u1.y * (1.0 - u1.x) + (d1 - b1) * u1.x * u1.y;

// --- Échantillon 3 : bruit décalé en Y ---
float2 P2 = P0 + float2(0.0, Epsilon);
float2 i2 = floor(P2);
float2 f2 = frac(P2);
float a2 = frac(sin(dot(i2,               float2(127.1, 311.7))) * 43758.5453123);
float b2 = frac(sin(dot(i2 + float2(1,0), float2(127.1, 311.7))) * 43758.5453123);
float c2 = frac(sin(dot(i2 + float2(0,1), float2(127.1, 311.7))) * 43758.5453123);
float d2 = frac(sin(dot(i2 + float2(1,1), float2(127.1, 311.7))) * 43758.5453123);
float2 u2 = f2 * f2 * (3.0 - 2.0 * f2);
float n_dy = lerp(a2, b2, u2.x) + (c2 - a2) * u2.y * (1.0 - u2.x) + (d2 - b2) * u2.x * u2.y;

// --- Dérivées, rotation, atténuation ---
float dNdx = (n_dx - n_center) / Epsilon;
float dNdy = (n_dy - n_center) / Epsilon;

//TurbulenceIntensity = length(float2(dNdy, -dNdx));

float2 curl = normalize(float2(dNdy, -dNdx));

float dist = length(AttractorPosition - Position);
float weight = saturate(dist / AttractionRadius);
weight = weight * weight * weight;
curl *= weight * NoiseStrength;

CurlVelocity = float3(curl.x, curl.y, 0.0);